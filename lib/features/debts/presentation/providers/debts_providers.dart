import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../transactions/presentation/providers/transactions_providers.dart';
import '../../data/repositories/debt_repository_impl.dart';
import '../../domain/entities/debt.dart';
import '../../domain/repositories/debt_repository.dart';
import '../../domain/usecases/create_debt.dart';
import '../../domain/usecases/register_debt_payment.dart';
import '../../domain/usecases/suggest_debt_payment.dart';

final debtRepositoryProvider = Provider<DebtRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DebtRepositoryImpl(db);
});

final createDebtUseCaseProvider = Provider<CreateDebt>((ref) {
  return CreateDebt(ref.watch(debtRepositoryProvider));
});

final registerDebtPaymentUseCaseProvider = Provider<RegisterDebtPayment>((ref) {
  return RegisterDebtPayment(
    debtRepository: ref.watch(debtRepositoryProvider),
    categoryRepository: ref.watch(categoryRepositoryProvider),
    transactionRepository: ref.watch(transactionRepositoryProvider),
  );
});

final suggestDebtPaymentUseCaseProvider = Provider<SuggestDebtPayment>((ref) {
  return SuggestDebtPayment(ref.watch(debtRepositoryProvider));
});

final debtsWithBalanceStreamProvider = StreamProvider<List<DebtWithBalance>>((
  ref,
) {
  final repo = ref.watch(debtRepositoryProvider);
  return repo.watchDebtsWithBalance();
});

final debtStrategyProvider = FutureProvider<DebtStrategy>((ref) async {
  final repo = ref.watch(debtRepositoryProvider);
  final res = await repo.getDebtStrategy();
  return res.valueOrNull ?? DebtStrategy.avalanche;
});

final suggestedDebtPaymentProvider =
    FutureProvider.family<DebtPaymentSuggestion, int?>((
      ref,
      availableAmount,
    ) async {
      final useCase = ref.watch(suggestDebtPaymentUseCaseProvider);
      final res = await useCase(availableAmount: availableAmount);
      return res.valueOrNull ??
          const DebtPaymentSuggestion(
            targetDebt: null,
            suggestedAmount: 0,
            strategy: DebtStrategy.avalanche,
            rankedDebts: [],
          );
    });
