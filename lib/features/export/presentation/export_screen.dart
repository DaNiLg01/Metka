import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart'; // ✅ ДОБАВЛЕНО
import 'dart:io';
import 'dart:convert';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../expenses/data/services/storage_service.dart';
import '../../categories/data/category.dart';
import '../../categories/data/category_service.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isExporting = false;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _categories = await CategoryService.loadCategories();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Future<void> _exportToCsv() async {
    setState(() => _isExporting = true);

    try {
      final allExpenses = await StorageService.loadExpenses();

      // Фильтрация по периоду
      final filteredExpenses = allExpenses.where((e) {
        if (_startDate != null && e.date.isBefore(_startDate!)) return false;
        if (_endDate != null && e.date.isAfter(_endDate!.add(const Duration(days: 1)))) return false;
        return true;
      }).toList();

      // ✅ ПРОВЕРКА: если нет данных, показываем ошибку и НЕ создаём файл
      if (filteredExpenses.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.tr('noDataToExport')),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
        setState(() => _isExporting = false);
        return; // ✅ ВАЖНО: выходим из метода, файл не создаётся
      }

      // Генерация CSV
      final buffer = StringBuffer();
      buffer.writeln('Date;Category;Title;Description;Amount');

      for (final e in filteredExpenses) {
        final dateStr = DateFormat('dd.MM.yyyy').format(e.date);
        final cat = _categories.firstWhere(
              (c) => c.id == e.categoryId.toString(),
          orElse: () => Category(id: '0', name: 'Неизвестно', iconCode: 'more_horiz', colorValue: 0xFF9E9E9E),
        );
        final catStr = AppStrings.translateCategory(cat.name);

        final title = '"${e.title.replaceAll('"', '""').replaceAll(';', ',')}"';
        final desc = '"${e.description.replaceAll('"', '""').replaceAll(';', ',')}"';
        buffer.writeln('$dateStr;$catStr;$title;$desc;${e.amount.toStringAsFixed(2)}');
      }

      // Сохранение файла
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'expenses_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(buffer.toString(), encoding: utf8);

      // ✅ ОТКРЫВАЕМ SHARE-ДИАЛОГ
      if (!mounted) return;
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Экспорт расходов',
        text: 'Файл с историей расходов',
      );

      // Показываем успех ПОСЛЕ того, как пользователь выбрал, куда поделиться
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.tr('exportSuccess')}\nФайл: $fileName'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.tr('exportError', params: {'error': e.toString()})}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
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
          AppStrings.tr('exportToCsv'),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? AppColors.textLight : Colors.black87),
        ),
        iconTheme: IconThemeData(color: isDark ? AppColors.textLight : Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('exportPeriod'),
                    style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _startDate != null ? DateFormat('dd.MM.yyyy').format(_startDate!) : AppStrings.tr('from'),
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _selectStartDate,
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _endDate != null ? DateFormat('dd.MM.yyyy').format(_endDate!) : AppStrings.tr('to'),
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _selectEndDate,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: _isExporting ? null : _exportToCsv,
              icon: _isExporting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.download),
              label: Text(
                _isExporting ? AppStrings.tr('exporting') : AppStrings.tr('exportToCsv'),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}