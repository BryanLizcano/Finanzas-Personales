import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../transactions/presentation/providers/transactions_providers.dart';
import '../../data/repositories/savings_repository_impl.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/repositories/savings_repository.dart';
import '../../domain/usecases/contribute_to_goal.dart';
import '../../domain/usecases/create_savings_goal.dart';

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SavingsRepositoryImpl(db);
});

final createSavingsGoalUseCaseProvider = Provider<CreateSavingsGoal>((ref) {
  return CreateSavingsGoal(ref.watch(savingsRepositoryProvider));
});

final contributeToGoalUseCaseProvider = Provider<ContributeToGoal>((ref) {
  return ContributeToGoal(
    savingsRepository: ref.watch(savingsRepositoryProvider),
    accountRepository: ref.watch(accountRepositoryProvider),
    transactionRepository: ref.watch(transactionRepositoryProvider),
  );
});

final savingsGoalsWithProgressStreamProvider =
    StreamProvider<List<SavingsGoalWithProgress>>((ref) {
      final repo = ref.watch(savingsRepositoryProvider);
      return repo.watchGoalsWithProgress();
    });

final totalSavedAmountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(savingsRepositoryProvider);
  return repo.getTotalSavedAmount();
});
