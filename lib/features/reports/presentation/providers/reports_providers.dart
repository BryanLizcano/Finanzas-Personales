import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../../debts/presentation/providers/debts_providers.dart';
import '../../../receivables/presentation/providers/receivables_providers.dart';
import '../../../savings/presentation/providers/savings_providers.dart';
import '../../data/repositories/reports_repository_impl.dart';
import '../../domain/entities/report_models.dart';
import '../../domain/repositories/reports_repository.dart';
import '../../domain/usecases/get_category_breakdown.dart';
import '../../domain/usecases/get_monthly_summary.dart';
import '../../domain/usecases/get_monthly_totals.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReportsRepositoryImpl(
    db: db,
    debtRepository: ref.watch(debtRepositoryProvider),
    receivableRepository: ref.watch(receivableRepositoryProvider),
    savingsRepository: ref.watch(savingsRepositoryProvider),
    budgetRepository: ref.watch(budgetRepositoryProvider),
  );
});

final getMonthlySummaryUseCaseProvider = Provider<GetMonthlySummary>((ref) {
  return GetMonthlySummary(ref.watch(reportsRepositoryProvider));
});

final getCategoryBreakdownUseCaseProvider = Provider<GetCategoryBreakdown>((
  ref,
) {
  return GetCategoryBreakdown(ref.watch(reportsRepositoryProvider));
});

final getMonthlyTotalsUseCaseProvider = Provider<GetMonthlyTotals>((ref) {
  return GetMonthlyTotals(ref.watch(reportsRepositoryProvider));
});

final monthlySummaryProvider =
    FutureProvider.family<MonthlySummary, ({int year, int month})>((
      ref,
      params,
    ) async {
      final useCase = ref.watch(getMonthlySummaryUseCaseProvider);
      final res = await useCase(year: params.year, month: params.month);
      return res.valueOrNull ??
          MonthlySummary(
            year: params.year,
            month: params.month,
            totalIncome: 0,
            totalExpense: 0,
            balance: 0,
            totalDebtBalance: 0,
            totalReceivableBalance: 0,
            totalSaved: 0,
            baseIncome: 0,
            safeAvailable: 0,
          );
    });

final categoryBreakdownProvider =
    FutureProvider.family<List<CategoryBreakdownItem>, ({int year, int month})>(
      (ref, params) async {
        final useCase = ref.watch(getCategoryBreakdownUseCaseProvider);
        final res = await useCase(year: params.year, month: params.month);
        return res.valueOrNull ?? const [];
      },
    );

final monthlyTotalsProvider = FutureProvider<List<MonthlyTotalItem>>((
  ref,
) async {
  final useCase = ref.watch(getMonthlyTotalsUseCaseProvider);
  final res = await useCase();
  return res.valueOrNull ?? const [];
});

/// RN-22: Moto Report
final motoReportProvider =
    FutureProvider.family<GroupedExpenseReport, ({int year, int month})>((
      ref,
      params,
    ) async {
      final repo = ref.watch(reportsRepositoryProvider);
      final res = await repo.getGroupedExpenses(
        year: params.year,
        month: params.month,
        categoryKeys: const ['fuel', 'moto_maintenance', 'moto_documents'],
        groupName: 'Moto',
      );
      return res.valueOrNull ??
          const GroupedExpenseReport(
            groupName: 'Moto',
            categoryKeys: ['fuel', 'moto_maintenance', 'moto_documents'],
            totalAmount: 0,
          );
    });

/// RN-23: Couple & Outings Report
final coupleReportProvider =
    FutureProvider.family<GroupedExpenseReport, ({int year, int month})>((
      ref,
      params,
    ) async {
      final repo = ref.watch(reportsRepositoryProvider);
      final res = await repo.getGroupedExpenses(
        year: params.year,
        month: params.month,
        categoryKeys: const ['partner', 'outings'],
        groupName: 'Salidas y pareja',
      );
      return res.valueOrNull ??
          const GroupedExpenseReport(
            groupName: 'Salidas y pareja',
            categoryKeys: ['partner', 'outings'],
            totalAmount: 0,
          );
    });
