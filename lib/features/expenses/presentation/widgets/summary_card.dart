import 'package:flutter/material.dart';
import '../../../../core/localization/app_strings.dart';

class SummaryCard extends StatelessWidget {
  final double total;

  const SummaryCard({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = colorScheme.onSurfaceVariant;

    return Card(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.tr('totalForPeriod'),
              style: TextStyle(color: subtitleColor, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              '${total.toStringAsFixed(0)} ${AppStrings.getCurrencySymbol()}',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}