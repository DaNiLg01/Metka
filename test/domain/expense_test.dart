import 'package:flutter_test/flutter_test.dart';
// ✅ Импортируем нашу Domain Entity
import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';

void main() {
  group('Expense Entity Unit Tests', () {

    test('Должен корректно создавать объект Expense', () {
      // Arrange (Подготовка)
      final testDate = DateTime(2023, 10, 25);

      // Act (Действие)
      final expense = Expense(
        id: '123',
        title: 'Кофе',
        description: 'Утренний кофе',
        amount: 150.0,
        categoryId: 1,
        date: testDate,
      );

      // Assert (Проверка)
      expect(expense.id, '123');
      expect(expense.title, 'Кофе');
      expect(expense.amount, 150.0);
      expect(expense.categoryId, 1);
      expect(expense.date, testDate);
    });

    test('Должен корректно обновлять поля через copyWith', () {
      // Arrange
      final expense = Expense(
        id: '123',
        title: 'Кофе',
        description: '',
        amount: 150.0,
        categoryId: 1,
        date: DateTime(2023, 1, 1),
      );

      // Act: Меняем только сумму и название, остальное должно остаться прежним
      final updatedExpense = expense.copyWith(
        title: 'Латте',
        amount: 200.0,
      );

      // Assert
      expect(updatedExpense.title, 'Латте');       // Изменилось
      expect(updatedExpense.amount, 200.0);        // Изменилось
      expect(updatedExpense.categoryId, 1);        // Осталось прежним
      expect(updatedExpense.id, '123');            // Осталось прежним
    });

    test('Фабричный метод create должен генерировать ID и текущую дату', () {
      // Act
      final expense = Expense.create(
        title: 'Тест',
        description: 'Описание',
        amount: 500.0,
        categoryId: 2,
      );

      // Assert
      expect(expense.title, 'Тест');
      expect(expense.amount, 500.0);
      expect(expense.id.isNotEmpty, true); // ID сгенерирован
      expect(expense.date.isBefore(DateTime.now().add(const Duration(seconds: 1))), true); // Дата актуальна
    });
  });
}