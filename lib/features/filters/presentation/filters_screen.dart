import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/app_strings.dart';
import '../../expenses/data/models/filter_criteria.dart';
import '../../expenses/data/models/expense.dart';

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
  late TextEditingController _minAmountController;
  late TextEditingController _maxAmountController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _startDate = widget.currentCriteria.startDate;
    _endDate = widget.currentCriteria.endDate;
    _selectedCategories = Set.from(widget.currentCriteria.categories);
    _minAmountController = TextEditingController(
      text: widget.currentCriteria.minAmount?.toString() ?? '',
    );
    _maxAmountController = TextEditingController(
      text: widget.currentCriteria.maxAmount?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: _endDate ?? DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() { _startDate = date; });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() { _endDate = date; });
    }
  }

  void _applyFilters() {
    if (!_formKey.currentState!.validate()) return;

    final minAmount = double.tryParse(_minAmountController.text.trim());
    final maxAmount = double.tryParse(_maxAmountController.text.trim());

    final criteria = FilterCriteria(
      startDate: _startDate,
      endDate: _endDate,
      categories: _selectedCategories.toList(),
      minAmount: minAmount,
      maxAmount: maxAmount,
    );

    Navigator.pop(context, criteria);
  }

  void _resetFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedCategories.clear();
      _minAmountController.clear();
      _maxAmountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF121218);
    final subtitleColor = isDark ? const Color(0xFF8B8B9E) : const Color(0xFF666666);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.tr('filters'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(onPressed: _resetFilters, child: Text(AppStrings.tr('reset'), style: const TextStyle(fontSize: 16))),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: surfaceColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.tr('period'), style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _DateButton(label: AppStrings.tr('from'), date: _startDate, onTap: _selectStartDate, textColor: textColor, subtitleColor: subtitleColor)),
                            const SizedBox(width: 16),
                            Expanded(child: _DateButton(label: AppStrings.tr('to'), date: _endDate, onTap: _selectEndDate, textColor: textColor, subtitleColor: subtitleColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: surfaceColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.tr('category'), style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: ExpenseCategory.values.map((category) {
                            final isSelected = _selectedCategories.contains(category);
                            return FilterChip(
                              label: Text(AppStrings.translateCategory(category.name)),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedCategories.add(category);
                                  } else {
                                    _selectedCategories.remove(category);
                                  }
                                });
                              },
                              selectedColor: Color(category.colorValue).withOpacity(0.2),
                              checkmarkColor: Color(category.colorValue),
                              labelStyle: TextStyle(color: isSelected ? Color(category.colorValue) : textColor),
                              side: BorderSide(color: isSelected ? Color(category.colorValue) : subtitleColor.withOpacity(0.3)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Card(
                    color: surfaceColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.tr('amount'), style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _minAmountController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  style: TextStyle(color: textColor),
                                  decoration: InputDecoration(
                                    labelText: AppStrings.tr('minAmount'),
                                    labelStyle: TextStyle(color: subtitleColor),
                                    border: const UnderlineInputBorder(),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: subtitleColor.withOpacity(0.3))),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _maxAmountController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  style: TextStyle(color: textColor),
                                  decoration: InputDecoration(
                                    labelText: AppStrings.tr('maxAmount'),
                                    labelStyle: TextStyle(color: subtitleColor),
                                    border: const UnderlineInputBorder(),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: subtitleColor.withOpacity(0.3))),
                                    errorText: _validateAmountRange(),
                                    errorStyle: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _applyFilters,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF3D5A80),
                ),
                child: Text(AppStrings.tr('apply'), style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateAmountRange() {
    final minText = _minAmountController.text.trim();
    final maxText = _maxAmountController.text.trim();

    if (minText.isEmpty || maxText.isEmpty) return null;

    final min = double.tryParse(minText);
    final max = double.tryParse(maxText);

    if (min == null || max == null) return null;

    if (min > max) {
      return AppStrings.tr('invalidAmountRange');
    }
    return null;
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final Color textColor;
  final Color subtitleColor;

  const _DateButton({
    required this.label,
    required this.date,
    required this.onTap,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: subtitleColor),
          border: const UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: subtitleColor.withOpacity(0.3))),
        ),
        child: Text(
          date != null ? DateFormat('dd.MM.yyyy').format(date!) : AppStrings.tr('notSelected'),
          style: TextStyle(color: date != null ? textColor : subtitleColor),
        ),
      ),
    );
  }
}