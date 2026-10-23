import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/money/money.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/account.dart';
import '../providers/accounts_providers.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  IconData _accountIcon(AccountType type) {
    switch (type) {
      case AccountType.cash:
        return Icons.money_rounded;
      case AccountType.bank:
        return Icons.account_balance_rounded;
      case AccountType.savings:
        return Icons.savings_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final accountsAsync = ref.watch(accountsWithBalanceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAccountDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newAccount),
      ),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return EmptyStateWidget(
              title: l10n.emptyStateTitle,
              subtitle: l10n.emptyStateMessage,
              actionLabel: l10n.newAccount,
              onAction: () => _showAddAccountDialog(context, ref),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: accounts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = accounts[index];
              final acc = item.account;
              final balMoney = item.balance;

              String typeLabel;
              switch (acc.type) {
                case AccountType.cash:
                  typeLabel = l10n.accountTypeCash;
                  break;
                case AccountType.bank:
                  typeLabel = l10n.accountTypeBank;
                  break;
                case AccountType.savings:
                  typeLabel = l10n.accountTypeSavings;
                  break;
              }

              return Card(
                child: ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_accountIcon(acc.type), color: colors.primary),
                  ),
                  title: Text(
                    acc.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    typeLabel,
                    style: TextStyle(color: colors.onSurfaceMuted),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        balMoney.format(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded),
                        onSelected: (val) {
                          if (val == 'edit') {
                            _showEditAccountDialog(context, ref, acc);
                          } else if (val == 'archive') {
                            _showArchiveConfirmDialog(context, ref, acc);
                          }
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                          PopupMenuItem(
                            value: 'archive',
                            child: Text(l10n.accountArchived),
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
        loading: () => const Padding(
          padding: EdgeInsets.all(16.0),
          child: SkeletonList(itemCount: 4),
        ),
        error: (err, _) => ErrorStateWidget(
          customMessage: err.toString(),
          onRetry: () => ref.refresh(accountsWithBalanceProvider),
        ),
      ),
    );
  }

  void _showAddAccountDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencySettingProvider);

    final nameCtrl = TextEditingController();
    final balanceCtrl = TextEditingController(text: '0');
    var selectedType = AccountType.cash;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.newAccount),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: l10n.accountName),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<AccountType>(
                isExpanded: true,
                initialValue: selectedType,
                decoration: InputDecoration(labelText: l10n.accountType),
                items: [
                  DropdownMenuItem(
                    value: AccountType.cash,
                    child: Text(l10n.accountTypeCash),
                  ),
                  DropdownMenuItem(
                    value: AccountType.bank,
                    child: Text(l10n.accountTypeBank),
                  ),
                  DropdownMenuItem(
                    value: AccountType.savings,
                    child: Text(l10n.accountTypeSavings),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedType = val);
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: balanceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.accountInitialBalance,
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
                final balanceMajor = int.tryParse(balanceCtrl.text.trim()) ?? 0;
                final balanceUnits = Money.fromMajor(
                  balanceMajor,
                  currency,
                ).units;

                final createUseCase = ref.read(createAccountUseCaseProvider);
                final res = await createUseCase(
                  name: name,
                  type: selectedType,
                  initialBalance: balanceUnits,
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

  void _showEditAccountDialog(
    BuildContext context,
    WidgetRef ref,
    Account acc,
  ) {
    final l10n = AppLocalizations.of(context);
    final nameCtrl = TextEditingController(text: acc.name);
    var selectedType = acc.type;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.editAccount),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: l10n.accountName),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<AccountType>(
                isExpanded: true,
                initialValue: selectedType,
                decoration: InputDecoration(labelText: l10n.accountType),
                items: [
                  DropdownMenuItem(
                    value: AccountType.cash,
                    child: Text(l10n.accountTypeCash),
                  ),
                  DropdownMenuItem(
                    value: AccountType.bank,
                    child: Text(l10n.accountTypeBank),
                  ),
                  DropdownMenuItem(
                    value: AccountType.savings,
                    child: Text(l10n.accountTypeSavings),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedType = val);
                },
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
                final updateUseCase = ref.read(updateAccountUseCaseProvider);
                final res = await updateUseCase(
                  id: acc.id,
                  name: name,
                  type: selectedType,
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

  void _showArchiveConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    Account acc,
  ) {
    final l10n = AppLocalizations.of(context);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.accountArchiveConfirm),
        content: Text(l10n.accountArchiveNotice),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final archiveUseCase = ref.read(archiveAccountUseCaseProvider);
              await archiveUseCase(id: acc.id, archived: true);
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}
