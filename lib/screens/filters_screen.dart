import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/filter_criteria.dart';

class FiltersScreen extends StatefulWidget {
  final FilterCriteria currentCriteria;

  const FiltersScreen({super.key, required this.currentCriteria});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late List<ExpenseCategory> _selectedCategories;
  late TextEditingController _minAmountController;
  late TextEditingController _maxAmountController;

  @override
  void initState() {
    super.initState();
    _startDate = widget.currentCriteria.startDate;
    _endDate = widget.currentCriteria.endDate;
    _selectedCategories = List.from(widget.currentCriteria.categories);
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
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _endDate = date;
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
    final minAmount = _minAmountController.text.isEmpty
        ? null
        : double.tryParse(_minAmountController.text);
    final maxAmount = _maxAmountController.text.isEmpty
        ? null
        : double.tryParse(_maxAmountController.text);

    final criteria = FilterCriteria(
      startDate: _startDate,
      endDate: _endDate,
      categories: _selectedCategories,
      minAmount: minAmount,
      maxAmount: maxAmount,
    );

    Navigator.pop(context, criteria);
  }

  void _resetFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedCategories = [];
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
        title: const Text('Фильтры', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Сбросить'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Диапазон дат
            Card(
              color: surfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Период', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _DateField(
                            label: 'С',
                            date: _startDate,
                            onTap: _selectStartDate,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _DateField(
                            label: 'По',
                            date: _endDate,
                            onTap: _selectEndDate,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Категории
            Card(
              color: surfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Категории', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...ExpenseCategory.values.map((category) {
                      final isSelected = _selectedCategories.contains(category);
                      return CheckboxListTile(
                        title: Text(category.name, style: TextStyle(color: textColor)),
                        value: isSelected,
                        onChanged: (value) => _toggleCategory(category),
                        activeColor: const Color(0xFF3D5A80),
                        checkColor: Colors.white,
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Диапазон сумм
            Card(
              color: surfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Сумма', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minAmountController,
                            style: TextStyle(color: textColor),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'От',
                              labelStyle: TextStyle(color: subtitleColor),
                              border: const UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: subtitleColor.withOpacity(0.3)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _maxAmountController,
                            style: TextStyle(color: textColor),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'До',
                              labelStyle: TextStyle(color: subtitleColor),
                              border: const UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: subtitleColor.withOpacity(0.3)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Кнопка "Применить"
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _applyFilters,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF3D5A80),
                ),
                child: const Text('Применить', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final Color textColor;
  final Color subtitleColor;

  const _DateField({
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
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: subtitleColor.withOpacity(0.3)),
          ),
        ),
        child: Text(
          date != null ? '${date!.day}.${date!.month}.${date!.year}' : 'Не выбрано',
          style: TextStyle(color: date != null ? textColor : subtitleColor),
        ),
      ),
    );
  }
}