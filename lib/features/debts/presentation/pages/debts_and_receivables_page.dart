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
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../../receivables/domain/entities/receivable.dart';
import '../../../receivables/presentation/providers/receivables_providers.dart';
import '../../../reports/presentation/providers/reports_providers.dart';
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
                              Expanded(
                                child: Text(
                                  l10n.debtSuggestionTitle,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colors.debt,
                                      ),
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
                final feeMoney = Money(
                  units: debt.effectiveManagementFee,
                  currency: currency,
                );

                final progress = item.progressRatio;
                final daysUntilDue = item.daysUntilDue(now);
                final isOverdue = daysUntilDue < 0 && item.currentBalance > 0;
                final isDueSoon =
                    daysUntilDue >= 0 &&
                    daysUntilDue <= 3 &&
                    item.currentBalance > 0;

                final typeLabel = switch (debt.debtType) {
                  DebtType.personal => 'Persona',
                  DebtType.creditCard => 'Tarjeta',
                  DebtType.loan => 'Préstamo',
                };

                final termText = switch (debt.frequencyType) {
                  DebtFrequency.inDays =>
                    'Plazo: ${debt.intervalDays ?? 7} días',
                  DebtFrequency.biweekly => 'Cada 15 días',
                  DebtFrequency.monthly => 'Día ${debt.dueDay} de cada mes',
                };

                final interestText = debt.interestRateBp > 0
                    ? '${(debt.interestRateBp / 100).toStringAsFixed(1)}% mes'
                    : 'Sin interés (0%)';

                final String dueBadgeText;
                if (daysUntilDue < 0) {
                  dueBadgeText = 'Vencida hace ${-daysUntilDue} días';
                } else if (daysUntilDue == 0) {
                  dueBadgeText = '¡Vence hoy!';
                } else if (daysUntilDue <= 3) {
                  dueBadgeText = '${l10n.debtDueSoonAlert} ($daysUntilDue d)';
                } else {
                  dueBadgeText = 'Vence en $daysUntilDue días';
                }

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
                                  '$typeLabel • ${debt.creditor}',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: colors.debt,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                visualDensity: VisualDensity.compact,
                                tooltip: 'Editar deuda',
                                onPressed: () => _showAddDebtDialog(
                                  context,
                                  ref,
                                  existingDebt: debt,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  '${l10n.debtCurrentBalance}: ${currentMoney.format()}',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: colors.debt,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 8),
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
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Text(
                                debt.effectiveManagementFee > 0
                                    ? '${l10n.debtMinPayment}: ${minPayMoney.format()} + Manejo: ${feeMoney.format()}'
                                    : '${l10n.debtMinPayment}: ${minPayMoney.format()}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              Text(
                                '$interestText • $termText',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: colors.onSurfaceMuted),
                              ),
                            ],
                          ),
                          if (item.currentBalance > 0) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: (isOverdue || isDueSoon)
                                    ? colors.expense.withValues(alpha: 0.12)
                                    : colors.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    (isOverdue || isDueSoon)
                                        ? Icons.warning_amber_rounded
                                        : Icons.schedule_rounded,
                                    color: (isOverdue || isDueSoon)
                                        ? colors.expense
                                        : colors.primary,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    dueBadgeText,
                                    style: TextStyle(
                                      color: (isOverdue || isDueSoon)
                                          ? colors.expense
                                          : colors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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

  void _showAddDebtDialog(
    BuildContext context,
    WidgetRef ref, {
    DebtEntity? existingDebt,
  }) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencySettingProvider);
    final factor = currency.decimals == 0 ? 1 : 100;

    final nameCtrl = TextEditingController(text: existingDebt?.name ?? '');
    final creditorCtrl = TextEditingController(
      text: existingDebt?.creditor ?? '',
    );
    final amountCtrl = TextEditingController(
      text: existingDebt != null
          ? (existingDebt.initialAmount ~/ factor).toString()
          : '',
    );
    final minPayCtrl = TextEditingController(
      text: existingDebt != null
          ? (existingDebt.minPayment ~/ factor).toString()
          : '',
    );
    final interestCtrl = TextEditingController(
      text: existingDebt != null && existingDebt.interestRateBp > 0
          ? (existingDebt.interestRateBp / 100).toStringAsFixed(1)
          : '2.0',
    );
    final feeCtrl = TextEditingController(
      text: existingDebt != null && existingDebt.managementFee > 0
          ? (existingDebt.managementFee ~/ factor).toString()
          : '',
    );
    final dueDayCtrl = TextEditingController(
      text: (existingDebt?.dueDay ?? 15).toString(),
    );
    final intervalDaysCtrl = TextEditingController(
      text: (existingDebt?.intervalDays ?? 8).toString(),
    );

    DebtType selectedType = existingDebt?.debtType ?? DebtType.personal;
    bool hasInterest = existingDebt != null
        ? existingDebt.interestRateBp > 0
        : false;
    bool hasManagementFee = existingDebt?.hasManagementFee ?? false;
    DebtFrequency selectedFreq =
        existingDebt?.frequencyType ?? DebtFrequency.monthly;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final isPersonal = selectedType == DebtType.personal;
          final isDaysMode =
              selectedFreq == DebtFrequency.inDays ||
              selectedFreq == DebtFrequency.biweekly;

          return AlertDialog(
            title: Text(existingDebt == null ? l10n.newDebt : 'Editar deuda'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tipo de deuda',
                    style: Theme.of(ctx).textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ChoiceChip(
                        label: const Text('Persona (0% interés)'),
                        selected: selectedType == DebtType.personal,
                        onSelected: (_) => setModalState(() {
                          selectedType = DebtType.personal;
                          hasInterest = false;
                          hasManagementFee = false;
                        }),
                      ),
                      ChoiceChip(
                        label: const Text('Tarjeta de crédito'),
                        selected: selectedType == DebtType.creditCard,
                        onSelected: (_) => setModalState(() {
                          selectedType = DebtType.creditCard;
                        }),
                      ),
                      ChoiceChip(
                        label: const Text('Préstamo'),
                        selected: selectedType == DebtType.loan,
                        onSelected: (_) => setModalState(() {
                          selectedType = DebtType.loan;
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(labelText: l10n.debtName),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: creditorCtrl,
                    decoration: InputDecoration(
                      labelText: isPersonal
                          ? 'Nombre de la persona'
                          : l10n.debtCreditor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.debtInitialAmount,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: minPayCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.debtMinPayment,
                      hintText: 'Si es pago único, escribe el mismo monto',
                    ),
                  ),
                  if (!isPersonal) ...[
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: const Text('Sujeta a interés mensual'),
                      value: hasInterest,
                      onChanged: (v) => setModalState(() => hasInterest = v),
                    ),
                    if (hasInterest) ...[
                      TextField(
                        controller: interestCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.debtInterestRate,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: const Text('Tiene cuota de manejo'),
                      value: hasManagementFee,
                      onChanged: (v) =>
                          setModalState(() => hasManagementFee = v),
                    ),
                    if (hasManagementFee) ...[
                      TextField(
                        controller: feeCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Valor cuota de manejo',
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                  const SizedBox(height: 10),
                  Text(
                    'Plazo de pago',
                    style: Theme.of(ctx).textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ChoiceChip(
                        label: const Text('Mensual'),
                        selected: !isDaysMode,
                        onSelected: (_) => setModalState(() {
                          selectedFreq = DebtFrequency.monthly;
                        }),
                      ),
                      ChoiceChip(
                        label: const Text('En días (7, 8, 9, 15...)'),
                        selected: isDaysMode,
                        onSelected: (_) => setModalState(() {
                          selectedFreq = DebtFrequency.inDays;
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (isDaysMode) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [7, 8, 9, 15].map((d) {
                        final isSelected =
                            intervalDaysCtrl.text.trim() == d.toString();
                        return ActionChip(
                          label: Text('$d días'),
                          backgroundColor: isSelected
                              ? Theme.of(ctx).colorScheme.primary
                                    .withValues(alpha: 0.16)
                              : null,
                          onPressed: () => setModalState(() {
                            intervalDaysCtrl.text = d.toString();
                            selectedFreq = d == 15
                                ? DebtFrequency.biweekly
                                : DebtFrequency.inDays;
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: intervalDaysCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Plazo en días (ej. 7, 8, 9, 15)',
                      ),
                    ),
                  ] else ...[
                    TextField(
                      controller: dueDayCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.debtDueDay),
                    ),
                  ],
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
                  final amountUnits = Money.fromMajor(
                    amountMajor,
                    currency,
                  ).units;
                  final minPayMajor = int.tryParse(minPayCtrl.text.trim()) ?? 0;
                  final minPayUnits = minPayMajor > 0
                      ? Money.fromMajor(minPayMajor, currency).units
                      : amountUnits;

                  final interestPct = (!isPersonal && hasInterest)
                      ? (double.tryParse(interestCtrl.text.trim()) ?? 0.0)
                      : 0.0;
                  final interestBp = (interestPct * 100).round();

                  final feeMajor = (!isPersonal && hasManagementFee)
                      ? (int.tryParse(feeCtrl.text.trim()) ?? 0)
                      : 0;
                  final feeUnits = Money.fromMajor(feeMajor, currency).units;

                  final dueDay = (int.tryParse(dueDayCtrl.text.trim()) ?? 15)
                      .clamp(1, 31);
                  final intervalDays = isDaysMode
                      ? (int.tryParse(intervalDaysCtrl.text.trim()) ?? 7)
                      : null;

                  if (existingDebt == null) {
                    final createDebt = ref.read(createDebtUseCaseProvider);
                    final res = await createDebt(
                      name: name,
                      creditor: creditor,
                      initialAmount: amountUnits,
                      interestRateBp: interestBp,
                      minPayment: minPayUnits,
                      dueDay: dueDay,
                      debtType: selectedType,
                      hasManagementFee: !isPersonal && hasManagementFee,
                      managementFee: feeUnits,
                      frequencyType: selectedFreq,
                      intervalDays: intervalDays,
                    );

                    res.fold(
                      onOk: (_) {
                        ref.invalidate(debtsWithBalanceStreamProvider);
                        ref.invalidate(suggestedDebtPaymentProvider);
                        ref.invalidate(safeAvailableProvider);
                        ref.invalidate(monthlySummaryProvider);
                        Navigator.of(ctx).pop();
                      },
                      onError: (f) => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(content: Text(f.toLocalizedMessage(l10n))),
                          ),
                    );
                  } else {
                    final now = DateTime.now();
                    final nextDue = isDaysMode
                        ? DateTime(
                            now.year,
                            now.month,
                            now.day,
                          ).add(Duration(days: intervalDays ?? 7))
                        : null;
                    final repo = ref.read(debtRepositoryProvider);
                    final res = await repo.updateDebt(
                      id: existingDebt.id,
                      name: name,
                      creditor: creditor,
                      initialAmount: amountUnits,
                      interestRateBp: interestBp,
                      minPayment: minPayUnits,
                      dueDay: nextDue != null
                          ? nextDue.day.clamp(1, 31)
                          : dueDay,
                      debtType: selectedType,
                      hasManagementFee: !isPersonal && hasManagementFee,
                      managementFee: feeUnits,
                      frequencyType: selectedFreq,
                      intervalDays: intervalDays,
                      nextDueDate: nextDue,
                    );

                    res.fold(
                      onOk: (_) {
                        ref.invalidate(debtsWithBalanceStreamProvider);
                        ref.invalidate(suggestedDebtPaymentProvider);
                        ref.invalidate(safeAvailableProvider);
                        ref.invalidate(monthlySummaryProvider);
                        Navigator.of(ctx).pop();
                      },
                      onError: (f) => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(content: Text(f.toLocalizedMessage(l10n))),
                          ),
                    );
                  }
                },
                child: Text(l10n.save),
              ),
            ],
          );
        },
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
                isExpanded: true,
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
                    ref.invalidate(debtsWithBalanceStreamProvider);
                    ref.invalidate(suggestedDebtPaymentProvider);
                    ref.invalidate(accountsWithBalanceProvider);
                    ref.invalidate(safeAvailableProvider);
                    ref.invalidate(monthlySummaryProvider);
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
                onOk: (_) {
                  ref.invalidate(receivablesWithBalanceStreamProvider);
                  ref.invalidate(totalPendingReceivableProvider);
                  ref.invalidate(monthlySummaryProvider);
                  Navigator.of(ctx).pop();
                },
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
                isExpanded: true,
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
                    ref.invalidate(receivablesWithBalanceStreamProvider);
                    ref.invalidate(totalPendingReceivableProvider);
                    ref.invalidate(accountsWithBalanceProvider);
                    ref.invalidate(safeAvailableProvider);
                    ref.invalidate(monthlySummaryProvider);
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
