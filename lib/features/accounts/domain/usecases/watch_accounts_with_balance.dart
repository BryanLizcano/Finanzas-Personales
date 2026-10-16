import '../entities/account_with_balance.dart';
import '../repositories/account_repository.dart';

class WatchAccountsWithBalance {
  final AccountRepository _repository;

  const WatchAccountsWithBalance(this._repository);

  Stream<List<AccountWithBalance>> call({bool includeArchived = false}) {
    return _repository.watchAccountsWithBalance(
      includeArchived: includeArchived,
    );
  }
}
