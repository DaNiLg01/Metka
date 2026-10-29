import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import '../../../../core/localization/app_strings.dart';
import '../../expenses/data/services/storage_service.dart'; // ✅ ПРАВИЛЬНЫЙ ПУТЬ (2 уровня вверх)

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  bool _isExporting = false;
  String _statusMessage = '';

  Future<void> _exportAndShare() async {
    setState(() {
      _isExporting = true;
      _statusMessage = AppStrings.tr('exporting');
    });

    try {
      // 1. Загружаем данные
      final expenses = await StorageService.loadExpenses();

      if (expenses.isEmpty) {
        if (!mounted) return;
        setState(() {
          _isExporting = false;
          _statusMessage = AppStrings.tr('noDataToExport');
        });
        return;
      }

      final count = expenses.length;
      if (!mounted) return;
      setState(() {
        _statusMessage = AppStrings.tr('willBeExported').replaceAll('{count}', count.toString());
      });

      // Небольшая задержка для плавности UX
      await Future.delayed(const Duration(milliseconds: 500));

      // 2. Формируем данные для CSV
      final List<List<dynamic>> rows = [
        ['Дата', 'Категория', 'Название', 'Описание', 'Сумма'],
        ...expenses.map((e) => [
          '${e.date.day}.${e.date.month}.${e.date.year}',
          AppStrings.translateCategory(e.category.name),
          e.title,
          e.description,
          e.amount.toStringAsFixed(2),
        ]),
      ];

      // 3. Конвертируем в CSV строку
      final String csvData = const ListToCsvConverter().convert(rows);

      // 4. Сохраняем во временный файл
      final Directory tempDir = await getTemporaryDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final File file = File('${tempDir.path}/expenses_$timestamp.csv');
      await file.writeAsString(csvData, encoding: utf8);

      // 5. Делимся файлом через системное меню (Telegram, Почта и т.д.)
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Отчёт о расходах',
        text: 'Экспорт расходов из приложения',
      );

      if (mounted) {
        if (result.status == ShareResultStatus.success || result.status == ShareResultStatus.dismissed) {
          setState(() {
            _statusMessage = AppStrings.tr('exportSuccess');
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = '${AppStrings.tr('exportError')}: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.tr('exportCSV'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_download_outlined,
              size: 80,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.tr('exportToCsv'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _statusMessage.isEmpty
                  ? 'Будет экспортировано записей: ${_isExporting ? '...' : '0'}'
                  : _statusMessage,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: _isExporting ? null : _exportAndShare,
                icon: _isExporting
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Icon(Icons.share),
                label: Text(
                  _isExporting ? AppStrings.tr('exporting') : AppStrings.tr('exportToCsv'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}