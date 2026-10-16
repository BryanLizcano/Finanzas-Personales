import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/money/money.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../receivables/domain/entities/receivable.dart';
import '../../../receivables/presentation/providers/receivables_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/debt.dart';
import '../providers/debts_providers.dart';

class DebtsAndReceivablesPage extends ConsumerStatefulWidget {
  const DebtsAndReceivablesPage({super.key});

  @override
  ConsumerState<DebtsAndReceivablesPage> createState() =>
      _DebtsAndReceivablesPageState();
}

class _DebtsAndReceivablesPageState
    extends ConsumerState<DebtsAndReceivablesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navDebts),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.primary,
          unselectedLabelColor: colors.onSurfaceMuted,
          indicatorColor: colors.primary,
          tabs: [
            Tab(text: l10n.debtsTab),
            Tab(text: l10n.receivablesTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_DebtsView(), _ReceivablesView()],
      ),
    );
  }
}

class _DebtsView extends ConsumerWidget {
  const _DebtsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencySettingProvider);

    final debtsAsync = ref.watch(debtsWithBalanceStreamProvider);
    final suggestionAsync = ref.watch(suggestedDebtPaymentProvider(null));

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDebtDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newDebt),
      ),
      body: debtsAsync.when(
        data: (debts) {
          if (debts.isEmpty) {
            return EmptyStateWidget(
              title: l10n.debtEmpty,
              subtitle: l10n.debtEmptySubtitle,
              actionLabel: l10n.newDebt,
              onAction: () => _showAddDebtDialog(context, ref),
            );
          }

          final now = DateTime.now();
          final currentDay = now.day;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // Smart Suggestion Card
              suggestionAsync.when(
                data: (suggestion) {
                  if (suggestion.targetDebt == null) {
                    return const SizedBox.shrink();
                  }
                  final debt = suggestion.targetDebt!.debt;
                  final strategyText =
                      suggestion.strategy == DebtStrategy.avalanche
                      ? l10n.strategyAvalanche
                      : l10n.strategySnowball;

                  return Card(
                    color: colors.debt.withValues(alpha: 0.08),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: colors.debt,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.debtSuggestionTitle,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colors.debt,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.debtSuggestionSubtitle(strategyText),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: colors.onSurfaceMuted),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${debt.name} (${debt.creditor})',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 8),

              // Debts list
              ...debts.map((item) {
                final debt = item.debt;
                final initialMoney = Money(
                  units: debt.initialAmount,
                  currency: currency,
                );
                final currentMoney = Money(
                  units: item.currentBalance,
                  currency: currency,
                );
                final minPayMoney = Money(
                  units: debt.minPayment,
                  currency: currency,
                );

                final progress = item.progressRatio;

                final daysUntilDue = debt.dueDay - currentDay;
                final isDueSoon = daysUntilDue >= 0 && daysUntilDue <= 3;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  debt.name,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.debt.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  debt.creditor,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: colors.debt,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${l10n.debtCurrentBalance}: ${currentMoney.format()}',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: colors.debt,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'de ${initialMoney.format()}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: colors.onSurfaceMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          AppProgressBar(
                            progress: progress,
                            color: colors.debt,
                            height: 6,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${l10n.debtMinPayment}: ${minPayMoney.format()}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              Text(
                                '${(debt.interestRateBp / 100).toStringAsFixed(1)}% mes • Día ${debt.dueDay}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: colors.onSurfaceMuted),
                              ),
                            ],
                          ),
                          if (isDueSoon) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.expense.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: colors.expense,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.debtDueSoonAlert,
                                    style: TextStyle(
                                      color: colors.expense,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: item.currentBalance <= 0
                                  ? null
                                  : () =>
                                        _showPaymentDialog(context, ref, item),
                              icon: const Icon(Icons.payment_rounded, size: 16),
                              label: Text(l10n.debtMakePayment),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16.0),
          child: SkeletonList(itemCount: 4),
        ),
        error: (err, _) => ErrorStateWidget(
          customMessage: err.toString(),
          onRetry: () => ref.refresh(debtsWithBalanceStreamProvider),
        ),
      ),
    );
  }

  void _showAddDebtDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencySettingProvider);

    final nameCtrl = TextEditingController();
    final creditorCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final interestCtrl = TextEditingController(text: '2.0');
    final minPayCtrl = TextEditingController();
    final dueDayCtrl = TextEditingController(text: '15');

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.newDebt),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: l10n.debtName),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: creditorCtrl,
                decoration: InputDecoration(labelText: l10n.debtCreditor),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.debtInitialAmount),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: interestCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: l10n.debtInterestRate),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: minPayCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.debtMinPayment),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dueDayCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.debtDueDay),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final creditor = creditorCtrl.text.trim();
              final amountMajor = int.tryParse(amountCtrl.text.trim()) ?? 0;
              final amountUnits = Money.fromMajor(amountMajor, currency).units;
              final interestPct =
                  double.tryParse(interestCtrl.text.trim()) ?? 0.0;
              final interestBp = (interestPct * 100).round();
              final minPayMajor = int.tryParse(minPayCtrl.text.trim()) ?? 0;
              final minPayUnits = Money.fromMajor(minPayMajor, currency).units;
              final dueDay = int.tryParse(dueDayCtrl.text.trim()) ?? 1;

              final createDebt = ref.read(createDebtUseCaseProvider);
              final res = await createDebt(
                name: name,
                creditor: creditor,
                initialAmount: amountUnits,
                interestRateBp: interestBp,
                minPayment: minPayUnits,
                dueDay: dueDay,
              );

              res.fold(
                onOk: (_) => Navigator.of(ctx).pop(),
                onError: (f) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(f.toLocalizedMessage(l10n))),
                ),
              );
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(
    BuildContext context,
    WidgetRef ref,
    DebtWithBalance debtWithBalance,
  ) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencySettingProvider);
    final accounts = ref.read(accountsWithBalanceProvider).asData?.value ?? [];

    final amountCtrl = TextEditingController();
    int? selectedAccountId = accounts.isNotEmpty
        ? accounts.first.account.id
        : null;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.debtMakePayment),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${debtWithBalance.debt.name} (${debtWithBalance.debt.creditor})',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.debtPaymentAmount,
                  hintText:
                      'Máx: ${Money(units: debtWithBalance.currentBalance, currency: currency).format()}',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: selectedAccountId,
                decoration: InputDecoration(
                  labelText: l10n.transactionSourceAccount,
                ),
                items: accounts.map((a) {
                  return DropdownMenuItem(
                    value: a.account.id,
                    child: Text('${a.account.name} (${a.balance.format()})'),
                  );
                }).toList(),
                onChanged: (val) =>
                    setModalState(() => selectedAccountId = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final amountMajor = int.tryParse(amountCtrl.text.trim()) ?? 0;
                final amountUnits = Money.fromMajor(
                  amountMajor,
                  currency,
                ).units;
                if (selectedAccountId == null || amountUnits <= 0) return;

                final payUseCase = ref.read(registerDebtPaymentUseCaseProvider);
                final res = await payUseCase(
                  debtId: debtWithBalance.debt.id,
                  amount: amountUnits,
                  accountId: selectedAccountId!,
                  occurredAt: DateTime.now(),
                );

                res.fold(
                  onOk: (_) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.transactionSaved)),
                    );
                  },
                  onError: (f) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(f.toLocalizedMessage(l10n))),
                  ),
                );
              },
              child: Text(l10n.confirm),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceivablesView extends ConsumerWidget {
  const _ReceivablesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencySettingProvider);

    final recAsync = ref.watch(receivablesWithBalanceStreamProvider);
    final totalPendingAsync = ref.watch(totalPendingReceivableProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReceivableDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newReceivable),
      ),
      body: recAsync.when(
        data: (receivables) {
          if (receivables.isEmpty) {
            return EmptyStateWidget(
              title: l10n.receivableEmpty,
              subtitle: l10n.receivableEmptySubtitle,
              actionLabel: l10n.newReceivable,
              onAction: () => _showAddReceivableDialog(context, ref),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // Total Pending Receivable Banner (RN-21: separate from balance)
              totalPendingAsync.when(
                data: (total) {
                  final totalMoney = Money(units: total, currency: currency);
                  return Card(
                    color: colors.primary.withValues(alpha: 0.08),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.homeTotalReceivables,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: colors.onSurfaceMuted,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                totalMoney.format(),
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.handshake_rounded,
                            color: colors.primary,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 8),

              ...receivables.map((item) {
                final rec = item.receivable;
                final initialMoney = Money(
                  units: rec.initialAmount,
                  currency: currency,
                );
                final pendingMoney = Money(
                  units: item.pendingBalance,
                  currency: currency,
                );

                final progress = item.progressRatio;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rec.person,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${l10n.receivablePendingBalance}: ${pendingMoney.format()}',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'de ${initialMoney.format()}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: colors.onSurfaceMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          AppProgressBar(
                            progress: progress,
                            color: colors.primary,
                            height: 6,
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: item.pendingBalance <= 0
                                  ? null
                                  : () => _showCollectionDialog(
                                      context,
                                      ref,
                                      item,
                                    ),
                              icon: const Icon(
                                Icons.download_rounded,
                                size: 16,
                              ),
                              label: Text(l10n.receivableRegisterCollection),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16.0),
          child: SkeletonList(itemCount: 4),
        ),
        error: (err, _) => ErrorStateWidget(
          customMessage: err.toString(),
          onRetry: () => ref.refresh(receivablesWithBalanceStreamProvider),
        ),
      ),
    );
  }

  void _showAddReceivableDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencySettingProvider);

    final personCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.newReceivable),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: personCtrl,
              decoration: InputDecoration(labelText: l10n.receivablePerson),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.receivableInitialAmount,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteCtrl,
              decoration: InputDecoration(labelText: l10n.transactionNote),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final person = personCtrl.text.trim();
              final amountMajor = int.tryParse(amountCtrl.text.trim()) ?? 0;
              final amountUnits = Money.fromMajor(amountMajor, currency).units;

              final createUseCase = ref.read(createReceivableUseCaseProvider);
              final res = await createUseCase(
                person: person,
                initialAmount: amountUnits,
                createdAt: DateTime.now(),
                note: noteCtrl.text.trim(),
              );

              res.fold(
                onOk: (_) => Navigator.of(ctx).pop(),
                onError: (f) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(f.toLocalizedMessage(l10n))),
                ),
              );
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showCollectionDialog(
    BuildContext context,
    WidgetRef ref,
    ReceivableWithBalance item,
  ) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencySettingProvider);
    final accounts = ref.read(accountsWithBalanceProvider).asData?.value ?? [];

    final amountCtrl = TextEditingController();
    int? selectedAccountId = accounts.isNotEmpty
        ? accounts.first.account.id
        : null;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.receivableRegisterCollection),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.receivable.person),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.transactionAmount,
                  hintText:
                      'Máx: ${Money(units: item.pendingBalance, currency: currency).format()}',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: selectedAccountId,
                decoration: InputDecoration(
                  labelText: l10n.transactionTargetAccount,
                ),
                items: accounts.map((a) {
                  return DropdownMenuItem(
                    value: a.account.id,
                    child: Text('${a.account.name} (${a.balance.format()})'),
                  );
                }).toList(),
                onChanged: (val) =>
                    setModalState(() => selectedAccountId = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final amountMajor = int.tryParse(amountCtrl.text.trim()) ?? 0;
                final amountUnits = Money.fromMajor(
                  amountMajor,
                  currency,
                ).units;
                if (selectedAccountId == null || amountUnits <= 0) return;

                final collectUseCase = ref.read(
                  registerCollectionUseCaseProvider,
                );
                final res = await collectUseCase(
                  receivableId: item.receivable.id,
                  amount: amountUnits,
                  accountId: selectedAccountId!,
                  occurredAt: DateTime.now(),
                );

                res.fold(
                  onOk: (_) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.transactionSaved)),
                    );
                  },
                  onError: (f) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(f.toLocalizedMessage(l10n))),
                  ),
                );
              },
              child: Text(l10n.confirm),
            ),
          ],
        ),
      ),
    );
  }
}
