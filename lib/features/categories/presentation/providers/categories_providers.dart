import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/set_category_active.dart';
import '../../domain/usecases/update_category.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CategoryRepositoryImpl(db);
});

final createCategoryUseCaseProvider = Provider<CreateCategory>((ref) {
  return CreateCategory(ref.watch(categoryRepositoryProvider));
});

final setCategoryActiveUseCaseProvider = Provider<SetCategoryActive>((ref) {
  return SetCategoryActive(ref.watch(categoryRepositoryProvider));
});

final updateCategoryUseCaseProvider = Provider<UpdateCategory>((ref) {
  return UpdateCategory(ref.watch(categoryRepositoryProvider));
});

final allCategoriesProvider = StreamProvider<List<Category>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.watchCategories();
});

final activeExpenseCategoriesProvider = StreamProvider<List<Category>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.watchCategories(kind: CategoryKind.expense, onlyActive: true);
});

final activeIncomeCategoriesProvider = StreamProvider<List<Category>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.watchCategories(kind: CategoryKind.income, onlyActive: true);
});
