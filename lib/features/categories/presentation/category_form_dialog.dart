import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../data/category.dart';
import '../data/category_service.dart';

class CategoryFormDialog extends StatefulWidget {
  final Category? category;

  const CategoryFormDialog({super.key, this.category});

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedIconCode;
  late int _selectedColorValue;
  List<Category> _existingCategories = [];

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

  final List<int> _availableColors = [
    0xFF3D5A80, 0xFF4CAF50, 0xFF9C27B0, 0xFFFF5722,
    0xFF00BCD4, 0xFF9E9E9E, 0xFFFFC107, 0xFFE91E63,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIconCode = widget.category?.iconCode ?? 'restaurant';
    _selectedColorValue = widget.category?.colorValue ?? 0xFF3D5A80;
    _loadExistingCategories();
  }

  Future<void> _loadExistingCategories() async {
    final categories = await CategoryService.loadCategories();
    setState(() {
      _existingCategories = categories;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF121218);
    final subtitleColor = isDark ? const Color(0xFF8B8B9E) : const Color(0xFF666666);

    return AlertDialog(
      backgroundColor: surfaceColor,
      title: Text(
        widget.category == null ? AppStrings.tr('newCategory') : AppStrings.tr('editCategory'),
        style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.tr('categoryName'), style: TextStyle(color: subtitleColor, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: AppStrings.tr('categoryName'),
                  hintStyle: TextStyle(color: subtitleColor),
                  border: const UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: subtitleColor.withOpacity(0.3))),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.tr('enterTitle');
                  }
                  final name = value.trim();
                  final isDuplicate = _existingCategories.any(
                        (c) => c.name.toLowerCase() == name.toLowerCase() && c.id != widget.category?.id,
                  );
                  if (isDuplicate) {
                    return AppStrings.tr('categoryAlreadyExists');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(AppStrings.tr('icon'), style: TextStyle(color: subtitleColor, fontSize: 14)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _availableIcons.map((iconMap) {
                  final iconKey = iconMap.keys.first;
                  final iconData = iconMap.values.first;
                  final isSelected = _selectedIconCode == iconKey;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIconCode = iconKey),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(_selectedColorValue).withOpacity(0.2) : surfaceColor,
                        border: Border.all(color: isSelected ? Color(_selectedColorValue) : subtitleColor.withOpacity(0.3), width: isSelected ? 2 : 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(iconData, color: isSelected ? Color(_selectedColorValue) : textColor, size: 24),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(AppStrings.tr('color'), style: TextStyle(color: subtitleColor, fontSize: 14)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12, runSpacing: 12,
                children: _availableColors.map((colorValue) {
                  final isSelected = _selectedColorValue == colorValue;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorValue = colorValue),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Color(colorValue), shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: isSelected ? 3 : 0),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.tr('cancel'), style: TextStyle(color: subtitleColor))),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, Category(
                id: widget.category?.id,
                name: _nameController.text.trim(),
                iconCode: _selectedIconCode,
                colorValue: _selectedColorValue,
              ));
            }
          },
          child: Text(AppStrings.tr('save')),
        ),
      ],
    );
  }
}