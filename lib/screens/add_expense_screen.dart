import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

/// Экран добавления/редактирования расхода
class AddExpenseScreen extends StatefulWidget {
  /// Если expense == null — режим создания, иначе — редактирование
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
  late ExpenseCategory _selectedCategory;
  late DateTime _selectedDate;
  bool _hasChanges = false;

  /// Проверяем, режим редактирования или создания
  bool get isEditMode => widget.expense != null;

  @override
  void initState() {
    super.initState();
    // Инициализация полей: если редактируем — заполняем существующими данными
    _titleController = TextEditingController(
      text: widget.expense?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.expense?.description ?? '',
    );
    _amountController = TextEditingController(
      text: widget.expense != null ? widget.expense!.amount.toString() : '',
    );
    _selectedCategory = widget.expense?.category ?? ExpenseCategory.food;
    _selectedDate = widget.expense?.date ?? DateTime.now();

    // Слушатели для отслеживания изменений (нужно для диалога "Выйти без сохранения")
    _titleController.addListener(_markChanged);
    _descriptionController.addListener(_markChanged);
    _amountController.addListener(_markChanged);
  }

  void _markChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Выбор даты через системный date picker
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

  /// Сохранение расхода
  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final expense = Expense(
      id: widget.expense?.id ?? Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: _selectedCategory,
      date: _selectedDate,
    );

    Navigator.pop(context, expense);
  }

  /// Удаление расхода (только в режиме редактирования)
  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить расход?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // 🔧 ИСПРАВЛЕНО: возвращаем строку 'DELETE' вместо null
      // Это нужно, чтобы HomeScreen отличил удаление от простого закрытия экрана
      Navigator.pop(context, 'DELETE');
    }
  }

  /// Проверка перед выходом (если есть несохранённые изменения)
  Future<bool> _confirmExit() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти без сохранения?'),
        content: const Text('Введённые данные будут потеряны.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Остаться'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF121218);
    final subtitleColor = isDark ? const Color(0xFF8B8B9E) : const Color(0xFF666666);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _confirmExit();
        if (shouldExit) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditMode ? 'Редактировать расход' : 'Новый расход',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          actions: [
            // Кнопка "Удалить" — только в режиме редактирования
            if (isEditMode)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _delete,
              ),
            // Кнопка "Сохранить"
            TextButton(
              onPressed: _save,
              child: const Text('Сохранить', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Поле "Название"
              Card(
                color: surfaceColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _titleController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Название',
                      labelStyle: TextStyle(color: subtitleColor),
                      border: const UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: subtitleColor.withOpacity(0.3)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите название';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Поле "Описание"
              Card(
                color: surfaceColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _descriptionController,
                    style: TextStyle(color: textColor),
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Описание',
                      labelStyle: TextStyle(color: subtitleColor),
                      border: const UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: subtitleColor.withOpacity(0.3)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Поле "Сумма"
              Card(
                color: surfaceColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _amountController,
                    style: TextStyle(color: textColor, fontSize: 20),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Сумма',
                      labelStyle: TextStyle(color: subtitleColor),
                      suffixText: '₽',
                      suffixStyle: TextStyle(color: subtitleColor),
                      border: const UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: subtitleColor.withOpacity(0.3)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите сумму';
                      }
                      final amount = double.tryParse(value.trim());
                      if (amount == null || amount <= 0) {
                        return 'Введите положительное число';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Поле "Дата"
              Card(
                color: surfaceColor,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text('Дата', style: TextStyle(color: subtitleColor, fontSize: 14)),
                  subtitle: Text(
                    DateFormat('dd.MM.yyyy').format(_selectedDate),
                    style: TextStyle(color: textColor, fontSize: 18),
                  ),
                  trailing: Icon(Icons.calendar_today, color: subtitleColor),
                  onTap: _selectDate,
                ),
              ),
              const SizedBox(height: 12),

              // Выбор категории
              Card(
                color: surfaceColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Категория', style: TextStyle(color: subtitleColor, fontSize: 14)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ExpenseCategory.values.map((category) {
                          final isSelected = _selectedCategory == category;
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
                                color: isSelected
                                    ? Color(category.colorValue)
                                    : surfaceColor,
                                border: Border.all(
                                  color: isSelected
                                      ? Color(category.colorValue)
                                      : subtitleColor.withOpacity(0.3),
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(category.icon, size: 18, color: isSelected ? Colors.white : textColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    category.name,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : textColor,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
}