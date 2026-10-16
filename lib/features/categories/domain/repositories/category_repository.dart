import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Result<Category, Failure>> createCategory({
    required String name,
    required CategoryKind kind,
    required String icon,
    required int color,
  });

  Future<Result<Category, Failure>> updateCategory({
    required int id,
    String? name,
    String? icon,
    int? color,
  });

  Future<Result<void, Failure>> setCategoryActive({
    required int id,
    required bool isActive,
  });

  Future<Result<void, Failure>> deleteCategory(int id);

  Future<Result<Category?, Failure>> getCategoryById(int id);

  Future<Result<Category?, Failure>> getCategoryByKey(String key);

  Stream<List<Category>> watchCategories({
    CategoryKind? kind,
    bool onlyActive = false,
  });

  Future<bool> hasTransactions(int categoryId);
}
