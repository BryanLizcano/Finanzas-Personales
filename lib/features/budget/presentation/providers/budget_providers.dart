import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../debts/presentation/providers/debts_providers.dart';
import '../../data/repositories/budget_repository_impl.dart';
import '../../domain/entities/allocation_rule.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/usecases/compute_extra_income_split.dart';
import '../../domain/usecases/compute_safe_available.dart';
import '../../domain/usecases/set_allocation_rules.dart';
import '../../domain/usecases/set_base_income.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BudgetRepositoryImpl(db);
});

final setBaseIncomeUseCaseProvider = Provider<SetBaseIncome>((ref) {
  return SetBaseIncome(ref.watch(budgetRepositoryProvider));
});

final setAllocationRulesUseCaseProvider = Provider<SetAllocationRules>((ref) {
  return SetAllocationRules(ref.watch(budgetRepositoryProvider));
});

final computeExtraIncomeSplitUseCaseProvider =
    Provider<ComputeExtraIncomeSplit>((ref) {
      return ComputeExtraIncomeSplit(ref.watch(budgetRepositoryProvider));
    });

final computeSafeAvailableUseCaseProvider = Provider<ComputeSafeAvailable>((
  ref,
) {
  return ComputeSafeAvailable(
    budgetRepository: ref.watch(budgetRepositoryProvider),
    debtRepository: ref.watch(debtRepositoryProvider),
  );
});

final baseIncomeStreamProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(budgetRepositoryProvider);
  return repo.watchBaseIncome();
});

final allocationRulesStreamProvider = StreamProvider<List<AllocationRule>>((
  ref,
) {
  final repo = ref.watch(budgetRepositoryProvider);
  return repo.watchAllocationRules();
});

final safeAvailableProvider = FutureProvider<SafeAvailableResult>((ref) async {
  final useCase = ref.watch(computeSafeAvailableUseCaseProvider);
  final res = await useCase();
  return res.valueOrNull ??
      const SafeAvailableResult(
        baseIncome: 0,
        fixedExpenses: 0,
        debtMinPayments: 0,
        savingsContribution: 0,
        safeAvailable: 0,
        isDeficit: false,
      );
});
