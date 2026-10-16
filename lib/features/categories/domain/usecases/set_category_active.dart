import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../repositories/category_repository.dart';

class SetCategoryActive {
  final CategoryRepository _repository;

  const SetCategoryActive(this._repository);

  Future<Result<void, Failure>> call({
    required int id,
    required bool isActive,
  }) async {
    return _repository.setCategoryActive(id: id, isActive: isActive);
  }
}
