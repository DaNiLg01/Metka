import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../data/category.dart';
import '../data/category_service.dart';
import '../../expenses/data/services/storage_service.dart';
import 'category_form_dialog.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await CategoryService.loadCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _showCategoryForm({Category? category}) async {
    final result = await showDialog<Category>(
      context: context,
      builder: (context) => CategoryFormDialog(category: category),
    );

    if (result != null) {
      if (category == null) {
        await CategoryService.addCategory(result);
      } else {
        await CategoryService.updateCategory(result);
      }
      _loadCategories();
    }
  }

  Future<void> _deleteCategory(Category category) async {
    final expenses = await StorageService.loadExpenses();
    final expensesCount = expenses.where((e) => e.category.name == category.name).length;

    bool confirmDelete = false;

    if (expensesCount > 0) {
      confirmDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppStrings.tr('cannotDeleteCategory')),
          content: Text(
            AppStrings.tr('categoryUsedInExpenses', params: {
              'name': AppStrings.translateCategory(category.name),
              'count': expensesCount.toString(),
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppStrings.tr('cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text(AppStrings.tr('deleteAnyway')),
            ),
          ],
        ),
      ) ??
          false;
    } else {
      confirmDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppStrings.tr('delete')),
          content: Text(
            AppStrings.tr('deleteCategoryConfirm', params: {'name': AppStrings.translateCategory(category.name)}),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppStrings.tr('cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppStrings.tr('delete')),
            ),
          ],
        ),
      ) ??
          false;
    }

    if (confirmDelete) {
      await CategoryService.deleteCategory(category.id);
      _loadCategories();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.tr('categoryDeleted')),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = colorScheme.surface;
    final textColor = colorScheme.onSurface;
    final subtitleColor = colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.tr('categoriesScreen'),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
        ),
      ),
      body: _categories.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category, size: 64, color: subtitleColor),
            const SizedBox(height: 16),
            Text(
              AppStrings.tr('noCategories'),
              style: TextStyle(color: subtitleColor, fontSize: 16),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Card(
            color: surfaceColor,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(category.iconData, color: category.color, size: 24),
              ),
              title: Text(
                AppStrings.translateCategory(category.name),
                style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: subtitleColor),
                    onPressed: () => _showCategoryForm(category: category),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.withOpacity(0.7)),
                    onPressed: () => _deleteCategory(category),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryForm(),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}