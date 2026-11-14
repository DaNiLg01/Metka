import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../expenses/domain/entities/expense.dart'; // ✅ ИМПОРТ ИЗ DOMAIN
import '../../expenses/data/services/storage_service.dart';
import '../data/stats_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<CategoryStats> _categoryStats = [];
  List<DailyStats> _dailyStats = [];
  double _totalAmount = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final expenses = await StorageService.loadExpenses();

      final categoryStats = await StatsService.getCategoryStats(expenses, null, null);
      final dailyStats = await StatsService.getDailyStats(expenses, null, null);

      setState(() {
        _categoryStats = categoryStats;
        _dailyStats = dailyStats;
        _totalAmount = categoryStats.fold(0.0, (sum, stat) => sum + stat.totalAmount);
      });
    } catch (e) {
      debugPrint('Ошибка загрузки статистики: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
        title: Text(
          AppStrings.tr('statsScreen'),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? AppColors.textLight : Colors.black87),
        ),
        iconTheme: IconThemeData(color: isDark ? AppColors.textLight : Colors.black87),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categoryStats.isEmpty
          ? Center(child: Text(AppStrings.tr('noExpenses'), style: TextStyle(color: colorScheme.onSurfaceVariant)))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    AppStrings.tr('totalForPeriod'),
                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_totalAmount.toStringAsFixed(2)} ${AppStrings.getCurrencySymbol()}',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('byCategories'),
                    style: TextStyle(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ..._categoryStats.map((stat) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(stat.colorValue).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getIconData(stat.iconCode),
                              color: Color(stat.colorValue),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.translateCategory(stat.categoryName),
                                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: stat.percentage / 100,
                                  backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(stat.colorValue)),
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${stat.totalAmount.toStringAsFixed(0)} ${AppStrings.getCurrencySymbol()}',
                                style: TextStyle(color: colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${stat.percentage.toStringAsFixed(0)}%',
                                style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('byDays'),
                    style: TextStyle(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: _dailyStats.isNotEmpty
                            ? _dailyStats.map((e) => e.totalAmount).reduce((a, b) => a > b ? a : b) * 1.2
                            : 100,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final stat = _dailyStats[group.x.toInt()];
                              return BarTooltipItem(
                                '${DateFormat('dd.MM').format(stat.date)}\n',
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: '${stat.totalAmount.toStringAsFixed(0)} ${AppStrings.getCurrencySymbol()}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() < _dailyStats.length) {
                                  final date = _dailyStats[value.toInt()].date;
                                  return Text(
                                    '${date.day}.${date.month}',
                                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: _dailyStats.asMap().entries.map((entry) {
                          final index = entry.key;
                          final stat = entry.value;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: stat.totalAmount,
                                color: colorScheme.primary,
                                width: 16,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconCode) {
    switch (iconCode) {
      case 'restaurant': return Icons.restaurant;
      case 'directions_car': return Icons.directions_car;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'movie': return Icons.movie;
      case 'favorite': return Icons.favorite;
      case 'more_horiz': return Icons.more_horiz;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'flight': return Icons.flight;
      case 'home': return Icons.home;
      default: return Icons.category;
    }
  }
}