import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseItem({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(expense.category.colorValue).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                expense.category.icon,
                color: Color(expense.category.colorValue),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF121218),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expense.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? const Color(0xFF8B8B9E) : const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '- ${expense.amount.toStringAsFixed(0)} ₽',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF121218),
              ),
            ),
          ],
        ),
      ),
    );
  }
}