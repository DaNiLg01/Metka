import 'package:get_it/get_it.dart';
import '../database/app_database.dart';
import '../../features/expenses/data/services/storage_service.dart';
import '../../features/categories/data/category_service.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';
import '../../features/expenses/data/repositories/expense_repository_impl.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. База данных
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // 2. Сервисы
  getIt.registerLazySingleton<StorageService>(() {
    StorageService.init(getIt<AppDatabase>());
    return StorageService();
  });

  getIt.registerLazySingleton<CategoryService>(() {
    CategoryService.init(getIt<AppDatabase>());
    return CategoryService();
  });

  // 3. РЕГИСТРАЦИЯ РЕПОЗИТОРИЯ
  getIt.registerLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl());

  // 4. Принудительная инициализация
  getIt<AppDatabase>();
  getIt<StorageService>();
  getIt<CategoryService>();
  getIt<ExpenseRepository>();
}