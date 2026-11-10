import 'package:flutter/material.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../expenses/data/models/expense.dart';
import '../../expenses/data/models/filter_criteria.dart';
import '../../categories/data/category.dart';
import '../../categories/data/category_service.dart';

class FiltersScreen extends StatefulWidget {
  final FilterCriteria currentCriteria;

  const FiltersScreen({super.key, required this.currentCriteria});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late Set<ExpenseCategory> _selectedCategories;
  late double? _minAmount;
  late double? _maxAmount;
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _startDate = widget.currentCriteria.startDate;
    _endDate = widget.currentCriteria.endDate;
    _selectedCategories = Set.from(widget.currentCriteria.categories);
    _minAmount = widget.currentCriteria.minAmount;
    _maxAmount = widget.currentCriteria.maxAmount;
    _minController.text = _minAmount?.toString() ?? '';
    _maxController.text = _maxAmount?.toString() ?? '';
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryService.loadCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
        });
      }
    } catch (e) {
      // Игнорируем ошибку загрузки категорий
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _toggleCategory(ExpenseCategory category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _applyFilters() {
    final minText = _minController.text.trim();
    final maxText = _maxController.text.trim();

    double? min;
    double? max;

    if (minText.isNotEmpty) {
      min = double.tryParse(minText);
    }
    if (maxText.isNotEmpty) {
      max = double.tryParse(maxText);
    }

    // ✅ Используем AppStrings.tr для сообщения об ошибке
    if (min != null && max != null && min > max) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.tr('invalidAmountRange'),
            style: const TextStyle(fontSize: 14),
          ),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if ((min != null && min < 0) || (max != null && max < 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.tr('enterPositiveNumber')),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final criteria = FilterCriteria(
      startDate: _startDate,
      endDate: _endDate,
      categories: _selectedCategories.toList(),
      minAmount: min,
      maxAmount: max,
    );

    Navigator.pop(context, criteria);
  }

  void _resetFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedCategories.clear();
      _minController.clear();
      _maxController.clear();
      _minAmount = null;
      _maxAmount = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.tr('filters'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== ДАТЫ =====
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('dateRange'),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _startDate != null
                          ? '${_startDate!.day}.${_startDate!.month}.${_startDate!.year}'
                          : AppStrings.tr('startDate'),
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _selectStartDate,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _endDate != null
                          ? '${_endDate!.day}.${_endDate!.month}.${_endDate!.year}'
                          : AppStrings.tr('endDate'),
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _selectEndDate,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ===== СУММА =====
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('amount'),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _minController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: AppStrings.tr('sumFrom'),
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                      ),
                      suffixText: AppStrings.getCurrencySymbol(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _maxController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: AppStrings.tr('sumTo'),
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                      ),
                      suffixText: AppStrings.getCurrencySymbol(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ===== КАТЕГОРИИ =====
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('categories'),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ExpenseCategory.values.map((category) {
                      final isSelected = _selectedCategories.contains(category);
                      return GestureDetector(
                        onTap: () => _toggleCategory(category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(category.colorValue) : colorScheme.surface,
                            border: Border.all(
                              color: isSelected ? Color(category.colorValue) : colorScheme.onSurfaceVariant.withOpacity(0.5),
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                category.icon,
                                size: 16,
                                color: isSelected ? Colors.white : colorScheme.onSurface,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppStrings.translateCategory(category.name),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : colorScheme.onSurface,
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

          // ===== КНОПКИ =====
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetFilters,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: colorScheme.primary),
                  ),
                  child: Text(
                    AppStrings.tr('reset'),
                    style: TextStyle(color: colorScheme.primary, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: _applyFilters,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: colorScheme.primary,
                  ),
                  child: Text(
                    AppStrings.tr('apply'),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}