import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/expense.dart'; // ✅ ИМПОРТИРУЕМ DOMAIN ENTITY
import '../../../categories/data/category.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final Category category;

  const ExpenseItem({
    super.key,
    required this.expense,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: colorScheme.surface,
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
          expense.title,
          style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${AppStrings.translateCategory(category.name)} • ${DateFormat('dd.MM.yyyy').format(expense.date)}',
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
        ),
        trailing: Text(
          '${expense.amount.toStringAsFixed(2)} ${AppStrings.getCurrencySymbol()}',
          style: TextStyle(
            color: isDark ? AppColors.textLight : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}