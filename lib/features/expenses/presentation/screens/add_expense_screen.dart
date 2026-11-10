import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/expense.dart';
import '../../../categories/data/category.dart';
import '../../../categories/data/category_service.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  Category? _selectedCategory; // ✅ Может быть null, пока не загрузится
  late DateTime _selectedDate;
  bool _hasChanges = false;
  List<Category> _categories = [];

  bool get isEditMode => widget.expense != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense?.title ?? '');
    _descriptionController = TextEditingController(text: widget.expense?.description ?? '');
    _amountController = TextEditingController(text: widget.expense != null ? widget.expense!.amount.toString() : '');
    _selectedDate = widget.expense?.date ?? DateTime.now();

    _loadCategories(); // ✅ Загружаем категории при старте

    _titleController.addListener(_markChanged);
    _descriptionController.addListener(_markChanged);
    _amountController.addListener(_markChanged);
  }

  // ✅ ИСПРАВЛЕНО: Безопасная загрузка категорий без ошибок типов
  Future<void> _loadCategories() async {
    final categories = await CategoryService.loadCategories();
    setState(() {
      _categories = categories;

      if (widget.expense != null) {
        // Режим редактирования: ищем категорию по имени
        final found = categories.where((c) => c.name == widget.expense!.category.name).toList();
        _selectedCategory = found.isNotEmpty
            ? found.first
            : (categories.isNotEmpty ? categories.first : null);
      } else if (categories.isNotEmpty) {
        // Режим создания: выбираем первую категорию по умолчанию
        _selectedCategory = categories.first;
      }
    });
  }

  void _markChanged() {
    if (!_hasChanges) {
      setState(() { _hasChanges = true; });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _hasChanges = true;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) return; // ✅ Защита от null

    final expense = Expense(
      id: widget.expense?.id ?? Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: ExpenseCategory.values.firstWhere(
            (e) => e.name == _selectedCategory!.name,
        orElse: () => ExpenseCategory.other,
      ),
      date: _selectedDate,
    );

    Navigator.pop(context, expense);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.tr('deleteExpense')),
        content: Text(AppStrings.tr('cannotUndo')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppStrings.tr('cancel'))),
          FilledButton(onPressed: () => Navigator.pop(context, true), style: FilledButton.styleFrom(backgroundColor: Colors.red), child: Text(AppStrings.tr('delete'))),
        ],
      ),
    );

    if (confirmed == true) {
      Navigator.pop(context, 'DELETE');
    }
  }

  Future<bool> _confirmExit() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.tr('exitWithoutSaving')),
        content: Text(AppStrings.tr('dataWillBeLost')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.tr('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.tr('exit')),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _confirmExit();
        if (shouldExit) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
          title: Text(
            isEditMode ? AppStrings.tr('editExpense') : AppStrings.tr('addExpense'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : Colors.black87,
            ),
          ),
          iconTheme: IconThemeData(color: isDark ? AppColors.textLight : Colors.black87),
          actions: [
            if (isEditMode) IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: _delete),
            TextButton(onPressed: _save, child: Text(AppStrings.tr('save'), style: TextStyle(fontSize: 16, color: colorScheme.primary))),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: AppStrings.tr('title'),
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      border: const UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                      ),
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty) ? AppStrings.tr('enterTitle') : null,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                color: colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _descriptionController,
                    textInputAction: TextInputAction.newline,
                    maxLines: 3,
                    minLines: 2,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: AppStrings.tr('description'),
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      border: const UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                color: colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _amountController,
                    style: TextStyle(color: colorScheme.onSurface, fontSize: 20),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    decoration: InputDecoration(
                      labelText: AppStrings.tr('amount'),
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      suffixText: AppStrings.getCurrencySymbol(),
                      suffixStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      border: const UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return AppStrings.tr('enterAmount');
                      final amount = double.tryParse(value.trim().replaceAll(',', '.'));
                      if (amount == null || amount <= 0) return AppStrings.tr('enterPositiveNumber');
                      if (amount > 10000000) return AppStrings.tr('maxAmountExceeded');
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                color: colorScheme.surface,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(AppStrings.tr('date'), style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14)),
                  subtitle: Text(DateFormat('dd.MM.yyyy').format(_selectedDate), style: TextStyle(color: colorScheme.onSurface, fontSize: 18)),
                  trailing: Icon(Icons.calendar_today, color: colorScheme.onSurfaceVariant),
                  onTap: _selectDate,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                color: colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.tr('category'), style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14)),
                      const SizedBox(height: 12),

                      // ✅ Если категории ещё не загрузились, показываем индикатор
                      if (_categories.isEmpty)
                        const Center(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ))
                      else
                      // ✅ Показываем загруженные категории из БД
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _categories.map((category) {
                            final isSelected = _selectedCategory?.name == category.name;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                  _hasChanges = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? Color(category.colorValue) : colorScheme.surface,
                                  border: Border.all(
                                      color: isSelected ? Color(category.colorValue) : colorScheme.onSurfaceVariant.withOpacity(0.5),
                                      width: isSelected ? 2 : 1
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getIconData(category.iconCode),
                                      size: 18,
                                      color: isSelected ? Colors.white : colorScheme.onSurface,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      AppStrings.translateCategory(category.name),
                                      style: TextStyle(
                                          color: isSelected ? Colors.white : colorScheme.onSurface,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Преобразуем строку иконки в IconData
  IconData _getIconData(String iconCode) {
    switch (iconCode) {
      case 'restaurant': return Icons.restaurant;
      case 'directions_car': return Icons.directions_car;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'movie': return Icons.movie;
      case 'favorite': return Icons.favorite;
      case 'more_horiz': return Icons.more_horiz;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'flight': return Icons.flight;
      case 'home': return Icons.home;
      default: return Icons.category;
    }
  }
}