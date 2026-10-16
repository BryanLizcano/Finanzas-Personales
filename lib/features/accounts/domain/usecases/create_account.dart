import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

class CreateAccount {
  final AccountRepository _repository;

  const CreateAccount(this._repository);

  Future<Result<Account, Failure>> call({
    required String name,
    required AccountType type,
    required int initialBalance,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Account name cannot be empty'),
      );
    }
    return _repository.createAccount(
      name: trimmedName,
      type: type,
      initialBalance: initialBalance,
    );
  }
}
