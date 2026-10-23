import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/money/money.dart';
import '../../../../core/widgets/animated_count.dart';
import '../../../../core/widgets/balance_card.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/quick_actions_widget.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../core/widgets/transaction_tile.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../accounts/domain/entities/account_with_balance.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../debts/presentation/providers/debts_providers.dart';
import '../../../quick_add/presentation/providers/quick_add_providers.dart';
import '../../../receivables/presentation/providers/receivables_providers.dart';
import '../../../savings/presentation/providers/savings_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/providers/transactions_providers.dart';
import '../../../transactions/presentation/widgets/transaction_action_dialogs.dart';
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

    // Keep Android SummaryWidget in sync whenever safe available or monthly balance updates
    void syncSummaryWidget() {
      final safeUnits = ref
          .read(safeAvailableProvider)
          .asData
          ?.value
          .safeAvailable;
      final monthlyBalUnits = ref
          .read(
            monthlySummaryProvider((year: currentYear, month: currentMonth)),
          )
          .asData
          ?.value
          .balance;
      if (safeUnits != null && monthlyBalUnits != null) {
        ref
            .read(updateWidgetDataUseCaseProvider)(
              safeAvailable: safeUnits,
              monthlyBalance: monthlyBalUnits,
            )
            .ignore();
      }
    }

    ref.listen(safeAvailableProvider, (_, next) {
      if (next.hasValue) syncSummaryWidget();
    });
    ref.listen(
      monthlySummaryProvider((year: currentYear, month: currentMonth)),
      (_, next) {
        if (next.hasValue) syncSummaryWidget();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.savings_rounded,
                  color: colors.primary,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.appTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ],
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
          const SizedBox(width: 4),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: [
            // 1. Minimalist Hero Balance + Safe Available Card
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

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colors.outline.withValues(alpha: 0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.homeTotalBalance,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: colors.onSurfaceMuted,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                          ),
                          InkWell(
                            onTap: () => context.push('/accounts'),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceVariant,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 13,
                                    color: colors.onSurfaceMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${accounts.length} ${l10n.homeAccounts.toLowerCase()}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: colors.onSurfaceMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: AnimatedMoneyText(
                          money: totalMoney,
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: colors.onSurface,
                                letterSpacing: -0.8,
                              ),
                        ),
                      ),
                      safeAvailableAsync.when(
                        data: (res) {
                          final safeMoney = Money(
                            units: res.safeAvailable,
                            currency: currency,
                          );
                          final isDeficit = res.isDeficit;
                          final badgeColor = isDeficit
                              ? colors.expense
                              : colors.primary;

                          return Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isDeficit
                                        ? Icons.warning_amber_rounded
                                        : Icons.shield_outlined,
                                    color: badgeColor,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      isDeficit
                                          ? l10n.homeDeficitWarning
                                          : l10n.homeSafeAvailable,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: badgeColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    safeMoney.format(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: badgeColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SkeletonCard(height: 130),
              error: (e, _) => ErrorStateWidget(customMessage: e.toString()),
            ),
            const SizedBox(height: 14),

            // 2. Reference 2x2 Minimalist Quick Actions Widget
            QuickActionsWidget(
              onQuickEntry: () => context.push('/quick-add?kind=expense'),
              onNewTransfer: () =>
                  context.push('/add-transaction?kind=transfer'),
              onNewIncome: () => context.push('/quick-add?kind=income'),
              onNewExpense: () => context.push('/quick-add?kind=expense'),
            ),
            const SizedBox(height: 14),

            // 3. Extra Income Split Card if monthly income > base income (RN-06 to RN-12)
            _ExtraIncomeSplitSection(
              currentYear: currentYear,
              currentMonth: currentMonth,
            ),

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
                      ?.copyWith(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                TextButton(
                  onPressed: () => context.go('/transactions'),
                  child: Text(l10n.homeViewAll),
                ),
              ],
            ),
            const SizedBox(height: 6),

            recentTxAsync.when(
              data: (transactions) {
                final displayTxs = transactions.take(5).toList();
                if (displayTxs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colors.outline.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        l10n.transactionEmpty,
                        style: TextStyle(color: colors.onSurfaceMuted),
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
                        accountType: acc?.account.type,
                        toAccountName: toAcc?.account.name,
                        toAccountType: toAcc?.account.type,
                        onTap: () {
                          showTransactionDetailSheet(
                            context: context,
                            ref: ref,
                            transaction: tx,
                            currency: currency,
                            categoryTitle: catTitle,
                            category: cat,
                            accountName: acc?.account.name,
                            accountType: acc?.account.type,
                            toAccountName: toAcc?.account.name,
                            toAccountType: toAcc?.account.type,
                          );
                        },
                        confirmDismiss: (direction) async {
                          return await showTransactionDeleteConfirmDialog(
                            context,
                          );
                        },
                        onDismissed: () async {
                          await executeDeleteTransaction(
                            context: context,
                            ref: ref,
                            transaction: tx,
                          );
                        },
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

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Card(
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
