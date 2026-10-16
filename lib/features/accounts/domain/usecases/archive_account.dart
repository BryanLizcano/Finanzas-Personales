import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../repositories/account_repository.dart';

class ArchiveAccount {
  final AccountRepository _repository;

  const ArchiveAccount(this._repository);

  Future<Result<void, Failure>> call({
    required int id,
    required bool archived,
  }) async {
    return _repository.archiveAccount(id: id, archived: archived);
  }
}
