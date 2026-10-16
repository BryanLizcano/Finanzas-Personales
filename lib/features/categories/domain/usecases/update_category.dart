import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository _repository;

  const UpdateCategory(this._repository);

  Future<Result<Category, Failure>> call({
    required int id,
    String? name,
    String? icon,
    int? color,
  }) async {
    if (name != null && name.trim().isEmpty) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Category name cannot be empty'),
      );
    }
    return _repository.updateCategory(
      id: id,
      name: name?.trim(),
      icon: icon,
      color: color,
    );
  }
}
