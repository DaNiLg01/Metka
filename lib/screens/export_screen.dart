import 'dart:convert';
import 'dart:html' as html; // Импорт для скачивания файлов в браузере
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _recordCount = 0;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    // По умолчанию берем текущий месяц
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = now;
    _countRecords();
  }

  Future<void> _countRecords() async {
    final expenses = await StorageService.loadExpenses();
    final filtered = expenses.where((e) {
      if (_startDate != null && e.date.isBefore(_startDate!)) return false;
      if (_endDate != null && e.date.isAfter(_endDate!.add(const Duration(days: 1)))) return false;
      return true;
    }).length;

    setState(() {
      _recordCount = filtered;
    });
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
      });
      _countRecords();
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _endDate = date;
      });
      _countRecords();
    }
  }

  Future<void> _exportToCsv() async {
    if (_recordCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет данных для экспорта за выбранный период')),
      );
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      final expenses = await StorageService.loadExpenses();
      final filtered = expenses.where((e) {
        if (_startDate != null && e.date.isBefore(_startDate!)) return false;
        if (_endDate != null && e.date.isAfter(_endDate!.add(const Duration(days: 1)))) return false;
        return true;
      }).toList();

      // Формируем данные для CSV (согласно ТЗ: Дата, Сумма, Валюта, Категория, Комментарий)
      final List<List<dynamic>> rows = [
        ['Дата', 'Сумма', 'Валюта', 'Категория', 'Комментарий'], // Заголовки
        ...filtered.map((e) => [
          DateFormat('dd.MM.yyyy').format(e.date),
          e.amount.toStringAsFixed(2),
          'RUB',
          e.category.name,
          e.description,
        ]),
      ];

      // Конвертируем в CSV строку
      String csvData = const ListToCsvConverter().convert(rows);

      // ВАЖНО ПО ТЗ (Раздел 3.6): Добавляем BOM (Byte Order Mark) для корректного открытия в Excel
      csvData = '\uFEFF$csvData';

      // --- ЛОГИКА ДЛЯ ВЕБ-БРАУЗЕРА (CHROME) ---
      // Создаем Blob с указанием UTF-8 кодировки
      final blob = html.Blob([csvData], 'text/csv;charset=utf-8;');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Создаем невидимую ссылку и программно нажимаем на неё для скачивания
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'expenses_export_${DateTime.now().millisecondsSinceEpoch}.csv')
        ..click();

      // Очищаем память
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Файл CSV успешно сформирован и скачан!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при экспорте: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isExporting = false;
      });
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
        title: const Text('Экспорт CSV', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: surfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Период экспорта', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _DateButton(
                            label: 'С',
                            date: _startDate,
                            onTap: _selectStartDate,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _DateButton(
                            label: 'По',
                            date: _endDate,
                            onTap: _selectEndDate,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Предпросмотр
            Card(
              color: surfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: const Color(0xFF3D5A80)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Будет экспортировано записей: $_recordCount',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Кнопка экспорта
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isExporting ? null : _exportToCsv,
                icon: _isExporting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.download, size: 24),
                label: Text(_isExporting ? 'Формирование...' : 'Экспортировать в CSV', style: const TextStyle(fontSize: 16)),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF3D5A80),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final Color textColor;
  final Color subtitleColor;

  const _DateButton({
    required this.label,
    required this.date,
    required this.onTap,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: subtitleColor),
          border: const UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: subtitleColor.withOpacity(0.3)),
          ),
        ),
        child: Text(
          date != null ? DateFormat('dd.MM.yyyy').format(date!) : 'Не выбрано',
          style: TextStyle(color: date != null ? textColor : subtitleColor),
        ),
      ),
    );
  }
}