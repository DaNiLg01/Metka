import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.food;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final expense = Expense.create(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      amount: double.parse(_amountCtrl.text.trim()),
      category: _category,
    );
    Navigator.pop(context, expense);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF121218);
    final hintColor = isDark ? const Color(0xFF8B8B9E) : const Color(0xFF666666);
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый расход'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Сохранить',
                style: TextStyle(color: Color(0xFF3D5A80))),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Название',
                  labelStyle: TextStyle(color: hintColor),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: hintColor)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3D5A80))),
                ),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Введите название' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descCtrl,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Описание',
                  labelStyle: TextStyle(color: hintColor),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: hintColor)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3D5A80))),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _amountCtrl,
                style: TextStyle(color: textColor, fontSize: 24),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Сумма',
                  labelStyle: TextStyle(color: hintColor),
                  suffixText: '₽',
                  suffixStyle: TextStyle(color: hintColor, fontSize: 24),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: hintColor)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3D5A80))),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Введите сумму';
                  if (double.tryParse(v) == null) return 'Некорректное число';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Text('Категория',
                  style: TextStyle(fontSize: 16, color: hintColor)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ExpenseCategory.values.map((c) {
                  final sel = c == _category;
                  return ChoiceChip(
                    avatar: Icon(c.icon, size: 18,
                        color: sel ? Colors.white : Color(c.colorValue)),
                    label: Text(c.name),
                    selected: sel,
                    onSelected: (_) => setState(() => _category = c),
                    backgroundColor: surfaceColor,
                    selectedColor: Color(c.colorValue).withOpacity(0.3),
                    labelStyle: TextStyle(
                        color: sel ? Colors.white : hintColor),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}