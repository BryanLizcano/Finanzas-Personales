import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/money/money.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/savings_goal.dart';
import '../providers/savings_providers.dart';

class SavingsPage extends ConsumerWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencySettingProvider);

    final goalsAsync = ref.watch(savingsGoalsWithProgressStreamProvider);
    final totalSavedAsync = ref.watch(totalSavedAmountProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.savingsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGoalDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newGoal),
      ),
      body: goalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) {
            return EmptyStateWidget(
              title: l10n.savingsEmpty,
              subtitle: l10n.savingsEmptySubtitle,
              actionLabel: l10n.newGoal,
              onAction: () => _showAddGoalDialog(context, ref),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              totalSavedAsync.when(
                data: (total) {
                  final totalMoney = Money(units: total, currency: currency);
                  return Card(
                    color: colors.savings.withValues(alpha: 0.08),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.homeTotalSavings,
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
                                      color: colors.savings,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.savings_rounded,
                            color: colors.savings,
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
              const SizedBox(height: 12),

              ...goals.map((item) {
                final goal = item.goal;
                final targetMoney = Money(
                  units: goal.targetAmount,
                  currency: currency,
                );
                final savedMoney = Money(
                  units: item.currentAmount,
                  currency: currency,
                );
                final progress = item.progressRatio;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          AppCircularProgress(
                            progress: progress,
                            size: 70,
                            strokeWidth: 6,
                            color: colors.savings,
                            centerChild: Text(
                              '${(progress * 100).round()}%',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.savings,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal.name,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${savedMoney.format()} / ${targetMoney.format()}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: colors.onSurfaceMuted),
                                ),
                                if (goal.targetDate != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '${l10n.goalTargetDate}: ${DateFormat.yMMMd().format(goal.targetDate!)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: colors.onSurfaceMuted,
                                        ),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: OutlinedButton.icon(
                                    onPressed: () => _showContributeDialog(
                                      context,
                                      ref,
                                      item,
                                    ),
                                    icon: const Icon(
                                      Icons.add_circle_outline_rounded,
                                      size: 16,
                                    ),
                                    label: Text(l10n.goalContribute),
                                  ),
                                ),
                              ],
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
          onRetry: () => ref.refresh(savingsGoalsWithProgressStreamProvider),
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencySettingProvider);

    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    DateTime? targetDate;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.newGoal),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: l10n.goalName),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.goalTargetAmount),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 90)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2040),
                  );
                  if (picked != null) {
                    setModalState(() => targetDate = picked);
                  }
                },
                icon: const Icon(Icons.calendar_today_rounded, size: 16),
                label: Text(
                  targetDate != null
                      ? DateFormat.yMMMd().format(targetDate!)
                      : l10n.goalTargetDate,
                ),
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
                final name = nameCtrl.text.trim();
                final amountMajor = int.tryParse(amountCtrl.text.trim()) ?? 0;
                final amountUnits = Money.fromMajor(
                  amountMajor,
                  currency,
                ).units;

                final createUseCase = ref.read(
                  createSavingsGoalUseCaseProvider,
                );
                final res = await createUseCase(
                  name: name,
                  targetAmount: amountUnits,
                  targetDate: targetDate,
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
      ),
    );
  }

  void _showContributeDialog(
    BuildContext context,
    WidgetRef ref,
    SavingsGoalWithProgress item,
  ) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencySettingProvider);
    final accounts = ref.read(accountsWithBalanceProvider).asData?.value ?? [];

    final savingsAccounts = accounts
        .where((a) => a.account.type == AccountType.savings)
        .toList();
    final sourceAccounts = accounts
        .where((a) => a.account.type != AccountType.savings)
        .toList();

    if (savingsAccounts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Crea primero una cuenta de tipo "Ahorro" para recibir tus aportes.',
          ),
        ),
      );
      return;
    }

    final amountCtrl = TextEditingController();
    int? selectedSourceId = sourceAccounts.isNotEmpty
        ? sourceAccounts.first.account.id
        : null;
    int? selectedSavingsId = savingsAccounts.first.account.id;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.goalContribute),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.goal.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.transactionAmount,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: selectedSourceId,
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
                      setModalState(() => selectedSourceId = val),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: selectedSavingsId,
                  decoration: InputDecoration(
                    labelText: l10n.transactionTargetAccount,
                  ),
                  items: savingsAccounts.map((a) {
                    return DropdownMenuItem(
                      value: a.account.id,
                      child: Text('${a.account.name} (${a.balance.format()})'),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setModalState(() => selectedSavingsId = val),
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
                final amountMajor = int.tryParse(amountCtrl.text.trim()) ?? 0;
                final amountUnits = Money.fromMajor(
                  amountMajor,
                  currency,
                ).units;
                if (selectedSourceId == null ||
                    selectedSavingsId == null ||
                    amountUnits <= 0) {
                  return;
                }

                final contributeUseCase = ref.read(
                  contributeToGoalUseCaseProvider,
                );
                final res = await contributeUseCase(
                  goalId: item.goal.id,
                  amount: amountUnits,
                  sourceAccountId: selectedSourceId!,
                  targetSavingsAccountId: selectedSavingsId!,
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
