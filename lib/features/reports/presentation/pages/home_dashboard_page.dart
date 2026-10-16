import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/money/money.dart';
import '../../../../core/widgets/balance_card.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../core/widgets/transaction_tile.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../accounts/domain/entities/account_with_balance.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../debts/presentation/providers/debts_providers.dart';
import '../../../receivables/presentation/providers/receivables_providers.dart';
import '../../../savings/presentation/providers/savings_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/providers/transactions_providers.dart';
import '../providers/reports_providers.dart';

class HomeDashboardPage extends ConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencySettingProvider);

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    // Accounts for total balance
    final accountsAsync = ref.watch(accountsWithBalanceProvider);
    // Safe available
    final safeAvailableAsync = ref.watch(safeAvailableProvider);
    // Debts, Receivables, Savings totals
    final debtsAsync = ref.watch(debtsWithBalanceStreamProvider);
    final totalReceivablesAsync = ref.watch(totalPendingReceivableProvider);
    final totalSavingsAsync = ref.watch(totalSavedAmountProvider);

    // Recent transactions
    final recentTxAsync = ref.watch(
      transactionsStreamProvider(const TransactionFilter()),
    );
    final allCatsAsync = ref.watch(allCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: l10n.homeReports,
            onPressed: () => context.push('/reports'),
          ),
          IconButton(
            icon: const Icon(Icons.savings_outlined),
            tooltip: l10n.homeSavingsGoals,
            onPressed: () => context.push('/savings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(safeAvailableProvider);
          ref.invalidate(
            monthlySummaryProvider((year: currentYear, month: currentMonth)),
          );
          ref.invalidate(totalPendingReceivableProvider);
          ref.invalidate(totalSavedAmountProvider);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // 1. Total Balance Card
            accountsAsync.when(
              data: (accounts) {
                final totalBalanceUnits = accounts.fold<int>(
                  0,
                  (sum, a) => sum + a.balance.units,
                );
                final totalMoney = Money(
                  units: totalBalanceUnits,
                  currency: currency,
                );

                return BalanceCard(
                  title: l10n.homeTotalBalance,
                  money: totalMoney,
                  icon: Icons.account_balance_wallet_rounded,
                  accentColor: colors.primary,
                  subtitle:
                      '${accounts.length} ${l10n.homeAccounts.toLowerCase()}',
                  onTap: () => context.push('/accounts'),
                );
              },
              loading: () => const SkeletonCard(height: 100),
              error: (e, _) => ErrorStateWidget(customMessage: e.toString()),
            ),
            const SizedBox(height: 12),

            // 2. Safe Available Card (RN-05, RN-07)
            safeAvailableAsync.when(
              data: (res) {
                final safeMoney = Money(
                  units: res.safeAvailable,
                  currency: currency,
                );
                final isDeficit = res.isDeficit;

                return Card(
                  color: isDeficit
                      ? colors.expense.withValues(alpha: 0.08)
                      : colors.primary.withValues(alpha: 0.08),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.homeSafeAvailable,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDeficit
                                        ? colors.expense
                                        : colors.primary,
                                  ),
                            ),
                            Icon(
                              isDeficit
                                  ? Icons.warning_amber_rounded
                                  : Icons.shield_rounded,
                              color: isDeficit
                                  ? colors.expense
                                  : colors.primary,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          safeMoney.format(),
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isDeficit
                                    ? colors.expense
                                    : colors.primary,
                              ),
                        ),
                        if (isDeficit) ...[
                          const SizedBox(height: 4),
                          Text(
                            l10n.homeDeficitWarning,
                            style: TextStyle(
                              color: colors.expense,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
              loading: () => const SkeletonCard(height: 110),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),

            // 3. Extra Income Split Card if monthly income > base income (RN-06 to RN-12)
            _ExtraIncomeSplitSection(
              currentYear: currentYear,
              currentMonth: currentMonth,
            ),
            const SizedBox(height: 12),

            // 4. Metric summary cards row (Total Debts, Receivables, Savings)
            Row(
              children: [
                Expanded(
                  child: debtsAsync.when(
                    data: (debts) {
                      final totalDebt = debts.fold<int>(
                        0,
                        (sum, d) => sum + d.currentBalance,
                      );
                      final debtMoney = Money(
                        units: totalDebt,
                        currency: currency,
                      );
                      return BalanceCard(
                        title: l10n.homeTotalDebt,
                        money: debtMoney,
                        icon: Icons.credit_score_rounded,
                        accentColor: colors.debt,
                        onTap: () => context.go('/debts-receivables'),
                      );
                    },
                    loading: () => const SkeletonCard(height: 90),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: totalReceivablesAsync.when(
                    data: (total) {
                      final recMoney = Money(units: total, currency: currency);
                      return BalanceCard(
                        title: l10n.homeTotalReceivables,
                        money: recMoney,
                        icon: Icons.payments_rounded,
                        accentColor: colors.primary,
                        onTap: () => context.go('/debts-receivables'),
                      );
                    },
                    loading: () => const SkeletonCard(height: 90),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: totalSavingsAsync.when(
                    data: (total) {
                      final savMoney = Money(units: total, currency: currency);
                      return BalanceCard(
                        title: l10n.homeTotalSavings,
                        money: savMoney,
                        icon: Icons.savings_rounded,
                        accentColor: colors.savings,
                        onTap: () => context.push('/savings'),
                      );
                    },
                    loading: () => const SkeletonCard(height: 90),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 5. Recent Transactions Header + List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.homeRecentTransactions,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.go('/transactions'),
                  child: Text(l10n.homeViewAll),
                ),
              ],
            ),
            const SizedBox(height: 8),

            recentTxAsync.when(
              data: (transactions) {
                final displayTxs = transactions.take(5).toList();
                if (displayTxs.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          l10n.transactionEmpty,
                          style: TextStyle(color: colors.onSurfaceMuted),
                        ),
                      ),
                    ),
                  );
                }

                final accounts =
                    accountsAsync.asData?.value ?? <AccountWithBalance>[];
                final categories = allCatsAsync.asData?.value ?? <Category>[];

                return Column(
                  children: displayTxs.map((tx) {
                    final cat = categories
                        .where((Category c) => c.id == tx.categoryId)
                        .firstOrNull;
                    final acc = accounts
                        .where(
                          (AccountWithBalance a) =>
                              a.account.id == tx.accountId,
                        )
                        .firstOrNull;
                    final toAcc = accounts
                        .where(
                          (AccountWithBalance a) =>
                              a.account.id == tx.toAccountId,
                        )
                        .firstOrNull;

                    final catTitle =
                        cat?.displayName(
                          (String k) => l10n.translateCategoryKey(k),
                        ) ??
                        (tx.kind == TransactionKind.transfer
                            ? l10n.transactionTransfer
                            : l10n.transactionCategory);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TransactionTile(
                        transaction: tx,
                        currency: currency,
                        categoryTitle: catTitle,
                        iconName: cat?.icon,
                        categoryColor: cat != null ? Color(cat.color) : null,
                        accountName: acc?.account.name,
                        toAccountName: toAcc?.account.name,
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const SkeletonList(itemCount: 4),
              error: (err, _) =>
                  ErrorStateWidget(customMessage: err.toString()),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ExtraIncomeSplitSection extends ConsumerWidget {
  final int currentYear;
  final int currentMonth;

  const _ExtraIncomeSplitSection({
    required this.currentYear,
    required this.currentMonth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencySettingProvider);

    final summaryAsync = ref.watch(
      monthlySummaryProvider((year: currentYear, month: currentMonth)),
    );
    final baseIncomeAsync = ref.watch(baseIncomeStreamProvider);

    return summaryAsync.when(
      data: (summary) {
        return baseIncomeAsync.when(
          data: (baseIncome) {
            if (baseIncome <= 0 || summary.totalIncome <= baseIncome) {
              return const SizedBox.shrink();
            }

            final computeSplit = ref.watch(
              computeExtraIncomeSplitUseCaseProvider,
            );
            return FutureBuilder(
              future: computeSplit(actualMonthlyIncome: summary.totalIncome),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data?.isError == true) {
                  return const SizedBox.shrink();
                }

                final split = snapshot.data!.valueOrNull!;
                if (split.hasDeficit || split.totalExtraIncome <= 0) {
                  return const SizedBox.shrink();
                }

                final extraMoney = Money(
                  units: split.totalExtraIncome,
                  currency: currency,
                );
                final debtsMoney = Money(
                  units: split.debtsAmount,
                  currency: currency,
                );
                final savingsMoney = Money(
                  units: split.savingsAmount,
                  currency: currency,
                );
                final freeMoney = Money(
                  units: split.freeAmount,
                  currency: currency,
                );

                return Card(
                  color: colors.income.withValues(alpha: 0.08),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.call_split_rounded,
                              color: colors.income,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.homeExtraIncomeSplit,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.income,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Superaste tu ingreso base por ${extraMoney.format()}. Sugerencia de reparto (RN-10):',
                          style: TextStyle(
                            color: colors.onSurfaceMuted,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _splitBadge(
                              l10n.homeSplitDebts(50),
                              debtsMoney,
                              colors.debt,
                            ),
                            const SizedBox(width: 6),
                            _splitBadge(
                              l10n.homeSplitSavings(20),
                              savingsMoney,
                              colors.savings,
                            ),
                            const SizedBox(width: 6),
                            _splitBadge(
                              l10n.homeSplitFree(30),
                              freeMoney,
                              colors.income,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _splitBadge(String label, Money money, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              money.format(),
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
