import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

class UpdateAccount {
  final AccountRepository _repository;

  const UpdateAccount(this._repository);

  Future<Result<Account, Failure>> call({
    required int id,
    required String name,
    required AccountType type,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Account name cannot be empty'),
      );
    }
    return _repository.updateAccount(id: id, name: trimmedName, type: type);
  }
}
