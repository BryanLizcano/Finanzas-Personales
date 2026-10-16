import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../transactions/presentation/providers/transactions_providers.dart';
import '../../data/repositories/receivable_repository_impl.dart';
import '../../domain/entities/receivable.dart';
import '../../domain/repositories/receivable_repository.dart';
import '../../domain/usecases/create_receivable.dart';
import '../../domain/usecases/register_collection.dart';

final receivableRepositoryProvider = Provider<ReceivableRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReceivableRepositoryImpl(db);
});

final createReceivableUseCaseProvider = Provider<CreateReceivable>((ref) {
  return CreateReceivable(ref.watch(receivableRepositoryProvider));
});

final registerCollectionUseCaseProvider = Provider<RegisterCollection>((ref) {
  return RegisterCollection(
    receivableRepository: ref.watch(receivableRepositoryProvider),
    categoryRepository: ref.watch(categoryRepositoryProvider),
    transactionRepository: ref.watch(transactionRepositoryProvider),
  );
});

final receivablesWithBalanceStreamProvider =
    StreamProvider<List<ReceivableWithBalance>>((ref) {
      final repo = ref.watch(receivableRepositoryProvider);
      return repo.watchReceivablesWithBalance();
    });

final totalPendingReceivableProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(receivableRepositoryProvider);
  return repo.getTotalPendingReceivable();
});
