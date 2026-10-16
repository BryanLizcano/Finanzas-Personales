import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class CreateCategory {
  final CategoryRepository _repository;

  const CreateCategory(this._repository);

  Future<Result<Category, Failure>> call({
    required String name,
    required CategoryKind kind,
    required String icon,
    required int color,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Category name cannot be empty'),
      );
    }
    return _repository.createCategory(
      name: trimmedName,
      kind: kind,
      icon: icon,
      color: color,
    );
  }
}
