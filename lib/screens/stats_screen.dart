import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/app_strings.dart';
import '../services/stats_service.dart';
import '../services/storage_service.dart';
import '../models/expense.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _selectedPeriod = 'week';
  DateTime? _startDate;
  DateTime? _endDate;
  List<CategoryStats> _categoryStats = [];
  List<DailyStats> _dailyStats = [];
  double _totalAmount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setPeriod('week');
  }

  void _setPeriod(String period) {
    setState(() {
      _selectedPeriod = period;
      _isLoading = true;
    });

    final now = DateTime.now();
    DateTime? start;
    DateTime? end;

    switch (period) {
      case 'week':
        start = now.subtract(Duration(days: now.weekday - 1));
        end = now;
        break;
      case 'month':
        start = DateTime(now.year, now.month, 1);
        end = now;
        break;
      case 'custom':
        start = _startDate ?? now.subtract(const Duration(days: 7));
        end = _endDate ?? now;
        break;
    }

    _loadStats(start, end);
  }

  Future<void> _loadStats(DateTime? start, DateTime? end) async {
    final expenses = await StorageService.loadExpenses();
    final categoryStats = StatsService.getCategoryStats(expenses, start, end);
    final dailyStats = StatsService.getDailyStats(expenses, start, end);

    setState(() {
      _categoryStats = categoryStats;
      _dailyStats = dailyStats;
      _totalAmount = categoryStats.fold(0, (sum, stat) => sum + stat.totalAmount);
      _isLoading = false;
    });
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _setPeriod('custom');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF121218);
    final subtitleColor = isDark ? const Color(0xFF8B8B9E) : const Color(0xFF666666);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.tr('statsScreen'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Период
            Card(
              color: surfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.tr('period'),
                      style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _PeriodChip(
                          label: AppStrings.tr('week'),
                          isSelected: _selectedPeriod == 'week',
                          onTap: () => _setPeriod('week'),
                        ),
                        _PeriodChip(
                          label: AppStrings.tr('month'),
                          isSelected: _selectedPeriod == 'month',
                          onTap: () => _setPeriod('month'),
                        ),
                        _PeriodChip(
                          label: AppStrings.tr('custom'),
                          isSelected: _selectedPeriod == 'custom',
                          onTap: _selectDateRange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Всего за период
            Card(
              color: surfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.tr('totalForPeriod'),
                      style: TextStyle(color: subtitleColor, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_totalAmount.toStringAsFixed(0)} ₽',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // По категориям
            if (_categoryStats.isNotEmpty) ...[
              Card(
                color: surfaceColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.tr('byCategories'),
                        style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: _categoryStats.map((stat) {
                              return PieChartSectionData(
                                value: stat.totalAmount,
                                title: '${stat.percentage.toStringAsFixed(0)}%',
                                color: Color(stat.colorValue),
                                radius: 80,
                                titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              );
                            }).toList(),
                            centerSpaceRadius: 40,
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) return;
                                final touchedSection = pieTouchResponse.touchedSection!;
                                final stat = _categoryStats[touchedSection.touchedSectionIndex];
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${stat.categoryName}: ${stat.totalAmount.toStringAsFixed(0)} ₽'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._categoryStats.map((stat) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Color(stat.colorValue),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                stat.categoryName,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                            Text(
                              '${stat.totalAmount.toStringAsFixed(0)} ₽',
                              style: TextStyle(color: subtitleColor),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // По дням
            if (_dailyStats.isNotEmpty)
              Card(
                color: surfaceColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.tr('byDays'),
                        style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            barGroups: _dailyStats.map((stat) {
                              return BarChartGroupData(
                                x: _dailyStats.indexOf(stat), // ✅ ИСПРАВЛЕНО: строго int
                                barRods: [
                                  BarChartRodData(
                                    toY: stat.totalAmount,
                                    color: const Color(0xFF3D5A80),
                                    width: 16,
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                                  ),
                                ],
                              );
                            }).toList(),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final stat = _dailyStats[value.toInt()];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        '${stat.date.day}.${stat.date.month}',
                                        style: TextStyle(color: subtitleColor, fontSize: 10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (group) => const Color(0xFF3D5A80), // ✅ ИСПРАВЛЕНО для 0.69.2
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  final stat = _dailyStats[groupIndex];
                                  return BarTooltipItem(
                                    '${stat.date.day}.${stat.date.month}\n${stat.totalAmount.toStringAsFixed(0)} ₽',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  );
                                },
                                tooltipMargin: 8,
                              ),
                              touchCallback: (FlTouchEvent event, barTouchResponse) {
                                if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) return;

                                // ✅ ИСПРАВЛЕНО: правильный способ получить int индекс в fl_chart 0.69.x
                                final spot = barTouchResponse.spot!;
                                final int index = spot.touchedBarGroup.x;
                                final stat = _dailyStats[index];

                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${stat.date.day}.${stat.date.month}: ${stat.totalAmount.toStringAsFixed(0)} ₽'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3D5A80) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF3D5A80) : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}