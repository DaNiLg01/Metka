import 'package:flutter/material.dart';
import '../models/category.dart';

/// Диалог добавления/редактирования категории
class CategoryFormDialog extends StatefulWidget {
  final Category? category; // null = создание, не null = редактирование

  const CategoryFormDialog({super.key, this.category});

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedIcon;
  late Color _selectedColor;

  /// Доступные иконки
  final List<Map<String, IconData>> _availableIcons = [
    {'restaurant': Icons.restaurant},
    {'directions_car': Icons.directions_car},
    {'shopping_bag': Icons.shopping_bag},
    {'movie': Icons.movie},
    {'favorite': Icons.favorite},
    {'more_horiz': Icons.more_horiz},
    {'home': Icons.home},
    {'work': Icons.work},
    {'school': Icons.school},
    {'fitness_center': Icons.fitness_center},
  ];

  /// Доступные цвета
  final List<Color> _availableColors = [
    const Color(0xFF3D5A80),
    const Color(0xFF4CAF50),
    const Color(0xFF9C27B0),
    const Color(0xFFFF5722),
    const Color(0xFF00BCD4),
    const Color(0xFF9E9E9E),
    const Color(0xFFFFC107),
    const Color(0xFFE91E63),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIcon = widget.category?.iconCode ?? 'restaurant';
    _selectedColor = widget.category?.color != null
        ? Color(widget.category!.colorValue)
        : const Color(0xFF3D5A80);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final category = Category(
        id: widget.category?.id,
        name: _nameController.text.trim(),
        iconCode: _selectedIcon,
        colorValue: _selectedColor.value,
      );
      Navigator.pop(context, category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF121218);

    return AlertDialog(
      backgroundColor: surfaceColor,
      title: Text(
        widget.category == null ? 'Новая категория' : 'Редактировать категорию',
        style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Поле названия
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Название',
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  border: const UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor.withOpacity(0.3)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите название';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Выбор иконки
              Text('Иконка', style: TextStyle(color: textColor, fontSize: 16)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableIcons.map((iconMap) {
                  final iconKey = iconMap.keys.first;
                  final iconData = iconMap.values.first;
                  final isSelected = _selectedIcon == iconKey;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = iconKey;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? _selectedColor.withOpacity(0.2) : surfaceColor,
                        border: Border.all(
                          color: isSelected ? _selectedColor : textColor.withOpacity(0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(iconData, color: textColor, size: 24),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Выбор цвета
              Text('Цвет', style: TextStyle(color: textColor, fontSize: 16)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableColors.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? textColor : Colors.transparent,
                          width: isSelected ? 3 : 0,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Отмена', style: TextStyle(color: textColor.withOpacity(0.7))),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}