import '../../../../core/errors/failure.dart';
import '../../../../core/money/money.dart';
import '../../../../core/result/result.dart';
import '../entities/account.dart';
import '../entities/account_with_balance.dart';

abstract class AccountRepository {
  Future<Result<Account, Failure>> createAccount({
    required String name,
    required AccountType type,
    required int initialBalance,
  });

  Future<Result<Account, Failure>> updateAccount({
    required int id,
    required String name,
    required AccountType type,
  });

  Future<Result<void, Failure>> archiveAccount({
    required int id,
    required bool archived,
  });

  Future<Result<Account?, Failure>> getAccountById(int id);

  Stream<List<AccountWithBalance>> watchAccountsWithBalance({
    bool includeArchived = false,
  });

  Future<Result<Money, Failure>> getAccountBalance(int accountId);

  Future<bool> hasTransactions(int accountId);
}
