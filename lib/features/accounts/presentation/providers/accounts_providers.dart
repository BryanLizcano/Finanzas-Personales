import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../domain/entities/account_with_balance.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/usecases/archive_account.dart';
import '../../domain/usecases/create_account.dart';
import '../../domain/usecases/update_account.dart';
import '../../domain/usecases/watch_accounts_with_balance.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AccountRepositoryImpl(db);
});

final createAccountUseCaseProvider = Provider<CreateAccount>((ref) {
  return CreateAccount(ref.watch(accountRepositoryProvider));
});

final updateAccountUseCaseProvider = Provider<UpdateAccount>((ref) {
  return UpdateAccount(ref.watch(accountRepositoryProvider));
});

final archiveAccountUseCaseProvider = Provider<ArchiveAccount>((ref) {
  return ArchiveAccount(ref.watch(accountRepositoryProvider));
});

final watchAccountsWithBalanceUseCaseProvider =
    Provider<WatchAccountsWithBalance>((ref) {
      return WatchAccountsWithBalance(ref.watch(accountRepositoryProvider));
    });

final accountsWithBalanceProvider = StreamProvider<List<AccountWithBalance>>((
  ref,
) {
  final useCase = ref.watch(watchAccountsWithBalanceUseCaseProvider);
  return useCase();
});
