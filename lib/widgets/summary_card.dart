import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryCard extends StatelessWidget {
  final double total;

  const SummaryCard({super.key, required this.total});

  String get _monthName {
    final now = DateTime.now();
    return DateFormat('MMMM', 'ru_RU').format(now);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'За ${_monthName.toLowerCase()}',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? const Color(0xFF8B8B9E) : const Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '- ${total.toStringAsFixed(0)} ₽',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF121218),
            ),
          ),
        ],
      ),
    );
  }
}