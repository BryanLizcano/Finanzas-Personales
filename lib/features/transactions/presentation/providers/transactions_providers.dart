import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/restore_transaction.dart';
import '../../domain/usecases/transfer_between_accounts.dart';
import '../../domain/usecases/update_transaction.dart';
import '../../domain/usecases/watch_transactions.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TransactionRepositoryImpl(db);
});

final addTransactionUseCaseProvider = Provider<AddTransaction>((ref) {
  return AddTransaction(ref.watch(transactionRepositoryProvider));
});

final updateTransactionUseCaseProvider = Provider<UpdateTransaction>((ref) {
  return UpdateTransaction(ref.watch(transactionRepositoryProvider));
});

final deleteTransactionUseCaseProvider = Provider<DeleteTransaction>((ref) {
  return DeleteTransaction(ref.watch(transactionRepositoryProvider));
});

final restoreTransactionUseCaseProvider = Provider<RestoreTransaction>((ref) {
  return RestoreTransaction(ref.watch(transactionRepositoryProvider));
});

final transferBetweenAccountsUseCaseProvider =
    Provider<TransferBetweenAccounts>((ref) {
      return TransferBetweenAccounts(ref.watch(transactionRepositoryProvider));
    });

final watchTransactionsUseCaseProvider = Provider<WatchTransactions>((ref) {
  return WatchTransactions(ref.watch(transactionRepositoryProvider));
});

final transactionsStreamProvider =
    StreamProvider.family<List<TransactionEntity>, TransactionFilter?>((
      ref,
      filter,
    ) {
      final useCase = ref.watch(watchTransactionsUseCaseProvider);
      return useCase(filter);
    });
