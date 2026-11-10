import 'package:flutter/material.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../data/category.dart';

class CategoryFormDialog extends StatefulWidget {
  final Category? category;

  const CategoryFormDialog({super.key, this.category});

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late IconData _selectedIcon;
  late int _selectedColorValue;

  final List<IconData> _availableIcons = [
    Icons.restaurant, Icons.directions_car, Icons.shopping_bag,
    Icons.movie, Icons.favorite, Icons.more_horiz, Icons.shopping_cart, Icons.flight, Icons.home
  ];

  final List<int> _availableColors = [
    0xFF3D5A80, 0xFF4CAF50, 0xFF9C27B0, 0xFFFF5722,
    0xFF00BCD4, 0xFF9E9E9E, 0xFFE91E63, 0xFFFFC107
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIcon = widget.category?.iconData ?? Icons.category;
    _selectedColorValue = widget.category?.colorValue ?? 0xFF3D5A80;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    // Простое преобразование иконки в строку для сохранения
    String iconCode = 'category';
    if (_selectedIcon == Icons.restaurant) iconCode = 'restaurant';
    else if (_selectedIcon == Icons.directions_car) iconCode = 'directions_car';
    else if (_selectedIcon == Icons.shopping_bag) iconCode = 'shopping_bag';
    else if (_selectedIcon == Icons.movie) iconCode = 'movie';
    else if (_selectedIcon == Icons.favorite) iconCode = 'favorite';
    else if (_selectedIcon == Icons.more_horiz) iconCode = 'more_horiz';
    else if (_selectedIcon == Icons.shopping_cart) iconCode = 'shopping_cart';
    else if (_selectedIcon == Icons.flight) iconCode = 'flight';
    else if (_selectedIcon == Icons.home) iconCode = 'home';

    final newCategory = Category(
      id: widget.category?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      iconCode: iconCode,
      colorValue: _selectedColorValue,
    );

    Navigator.pop(context, newCategory);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок с гарантированной видимостью
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.category == null ? AppStrings.tr('newCategory') : AppStrings.tr('editCategory'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : Colors.black87, // ✅ Исправлено
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: isDark ? AppColors.textLight : Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppStrings.tr('categoryName'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty) ? AppStrings.tr('enterTitle') : null,
              ),
              const SizedBox(height: 16),

              Text(AppStrings.tr('icon'), style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableIcons.map((icon) {
                  final isSelected = _selectedIcon == icon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(_selectedColorValue).withOpacity(0.2) : Colors.transparent,
                        border: Border.all(color: isSelected ? Color(_selectedColorValue) : Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: isSelected ? Color(_selectedColorValue) : colorScheme.onSurface),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              Text(AppStrings.tr('color'), style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableColors.map((colorValue) {
                  final isSelected = _selectedColorValue == colorValue;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorValue = colorValue),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(colorValue),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected ? [const BoxShadow(color: Colors.black26, blurRadius: 4)] : null,
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppStrings.tr('cancel')),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _save,
                    child: Text(AppStrings.tr('save')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}