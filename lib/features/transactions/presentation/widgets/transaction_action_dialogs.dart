import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/money/currency.dart';
import '../../../../core/money/money.dart';
import '../../../../core/widgets/icon_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../debts/presentation/providers/debts_providers.dart';
import '../../../quick_add/presentation/providers/quick_add_providers.dart';
import '../../../receivables/presentation/providers/receivables_providers.dart';
import '../../../reports/presentation/providers/reports_providers.dart';
import '../../../savings/presentation/providers/savings_providers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transactions_providers.dart';

/// Shows an AlertDialog asking "¿Estás seguro de eliminar?" with "No" and "Sí" buttons.
Future<bool> showTransactionDeleteConfirmDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final colors = context.colors;

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.expense.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: colors.expense,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.deleteTransactionConfirmTitle,
              style: Theme.of(ctx).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Text(
        l10n.deleteTransactionConfirmMessage,
        style: Theme.of(ctx).textTheme.bodyMedium,
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(
            l10n.no,
            style: TextStyle(
              color: colors.onSurfaceMuted,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.expense,
            foregroundColor: colors.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            l10n.yes,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    ),
  );

  return result ?? false;
}

Future<void> _refreshAndSyncProviders(WidgetRef ref) async {
  ref.invalidate(accountsWithBalanceProvider);
  ref.invalidate(safeAvailableProvider);
  ref.invalidate(monthlySummaryProvider);
  ref.invalidate(debtsWithBalanceStreamProvider);
  ref.invalidate(receivablesWithBalanceStreamProvider);
  ref.invalidate(totalPendingReceivableProvider);
  ref.invalidate(savingsGoalsWithProgressStreamProvider);
  ref.invalidate(totalSavedAmountProvider);

  try {
    final now = DateTime.now();
    final safeRes = await ref.read(computeSafeAvailableUseCaseProvider)();
    final summaryRes = await ref.read(getMonthlySummaryUseCaseProvider)(
      year: now.year,
      month: now.month,
    );
    final safeAvail = safeRes.valueOrNull?.safeAvailable ?? 0;
    final monthlyBal = summaryRes.valueOrNull?.balance ?? 0;
    await ref.read(updateWidgetDataUseCaseProvider)(
      safeAvailable: safeAvail,
      monthlyBalance: monthlyBal,
    );
  } catch (_) {}
}

/// Executes soft-deletion with snackbar and provider synchronization.
Future<void> executeDeleteTransaction({
  required BuildContext context,
  required WidgetRef ref,
  required TransactionEntity transaction,
}) async {
  final l10n = AppLocalizations.of(context);
  final deleteTx = ref.read(deleteTransactionUseCaseProvider);
  await deleteTx(transaction.id);

  await _refreshAndSyncProviders(ref);

  if (context.mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.transactionDeleted),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () async {
              await ref.read(restoreTransactionUseCaseProvider)(transaction.id);
              await _refreshAndSyncProviders(ref);
            },
          ),
        ),
      );
  }
}

/// Opens a bottom sheet displaying transaction details, note editing (max 25 chars),
/// and an explicit delete button that triggers the confirmation modal.
void showTransactionDetailSheet({
  required BuildContext context,
  required WidgetRef ref,
  required TransactionEntity transaction,
  required Currency currency,
  String? categoryTitle,
  Category? category,
  String? accountName,
  AccountType? accountType,
  String? toAccountName,
  AccountType? toAccountType,
}) {
  final colors = context.colors;
  final l10n = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context).languageCode;
  final dateFormat = DateFormat.yMMMMd(locale).add_jm();

  final isIncome = transaction.kind == TransactionKind.income;
  final isExpense = transaction.kind == TransactionKind.expense;
  final isTransfer = transaction.kind == TransactionKind.transfer;

  final amountColor = isIncome
      ? colors.income
      : isExpense
      ? colors.expense
      : colors.primary;

  final sign = isIncome
      ? '+'
      : isExpense
      ? '-'
      : '';
  final money = Money(units: transaction.amount, currency: currency);

  final String flowLabel = isIncome
      ? 'Entrada'
      : isExpense
      ? 'Salida (Gasto)'
      : 'Transferencia';

  String currentNote = transaction.note;

  showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (modalCtx) {
      return StatefulBuilder(
        builder: (ctx, setSheetState) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Movement Type & Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: amountColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        flowLabel,
                        style: TextStyle(
                          color: amountColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        dateFormat.format(transaction.occurredAt),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(ctx).textTheme.labelSmall
                            ?.copyWith(color: colors.onSurfaceMuted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Big Amount
                Center(
                  child: Text(
                    '$sign${money.format(locale)}',
                    style: Theme.of(ctx).textTheme.headlineMedium?.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),

                // Category & Account info
                if (!isTransfer) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: category != null
                            ? Color(category.color).withValues(alpha: 0.14)
                            : colors.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        category != null
                            ? getIconData(category.icon)
                            : Icons.category_outlined,
                        color: category != null
                            ? Color(category.color)
                            : colors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      l10n.transactionCategory,
                      style: Theme.of(ctx).textTheme.labelSmall
                          ?.copyWith(color: colors.onSurfaceMuted),
                    ),
                    subtitle: Text(
                      categoryTitle ?? l10n.transactionCategory,
                      style: Theme.of(ctx).textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],

                // Account
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.savings.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: colors.savings,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    isTransfer
                        ? l10n.transactionSourceAccount
                        : l10n.selectAccount,
                    style: Theme.of(ctx).textTheme.labelSmall
                        ?.copyWith(color: colors.onSurfaceMuted),
                  ),
                  subtitle: Text(
                    accountName ?? 'Cuenta',
                    style: Theme.of(ctx).textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),

                if (isTransfer && toAccountName != null) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.input_rounded,
                        color: colors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      l10n.transactionTargetAccount,
                      style: Theme.of(ctx).textTheme.labelSmall
                          ?.copyWith(color: colors.onSurfaceMuted),
                    ),
                    subtitle: Text(
                      toAccountName,
                      style: Theme.of(ctx).textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],

                // Note / Annotation display & edit
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colors.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sticky_note_2_outlined,
                        size: 20,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.transactionAnnotation,
                              style: Theme.of(ctx).textTheme.labelSmall
                                  ?.copyWith(color: colors.onSurfaceMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentNote.isNotEmpty
                                  ? currentNote
                                  : 'Sin anotación (ej. Coca Cola)',
                              style: Theme.of(ctx).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontStyle: currentNote.isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                    color: currentNote.isEmpty
                                        ? colors.onSurfaceMuted
                                        : colors.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        tooltip: l10n.editAnnotation,
                        onPressed: () async {
                          final newNote = await showDialog<String>(
                            context: ctx,
                            builder: (dialogCtx) => _EditAnnotationDialog(
                              initialNote: currentNote,
                              l10n: l10n,
                            ),
                          );

                          if (newNote != null && ctx.mounted) {
                            final updateTx = ref.read(
                              updateTransactionUseCaseProvider,
                            );
                            final res = await updateTx(
                              id: transaction.id,
                              note: newNote,
                            );
                            if (res.isOk && ctx.mounted) {
                              setSheetState(() {
                                currentNote = res.valueOrNull?.note ?? newNote;
                              });
                            }
                            if (modalCtx.mounted) {
                              Navigator.of(modalCtx).pop();
                            }
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.transactionUpdated),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Delete Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.expense.withValues(alpha: 0.12),
                    foregroundColor: colors.expense,
                    elevation: 0,
                    side: BorderSide(
                      color: colors.expense.withValues(alpha: 0.4),
                      width: 1,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text(
                    'Eliminar movimiento',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    final confirmed = await showTransactionDeleteConfirmDialog(
                      ctx,
                    );
                    if (confirmed && modalCtx.mounted) {
                      Navigator.of(modalCtx).pop();
                      await executeDeleteTransaction(
                        context: context,
                        ref: ref,
                        transaction: transaction,
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _EditAnnotationDialog extends StatefulWidget {
  final String initialNote;
  final AppLocalizations l10n;

  const _EditAnnotationDialog({required this.initialNote, required this.l10n});

  @override
  State<_EditAnnotationDialog> createState() => _EditAnnotationDialogState();
}

class _EditAnnotationDialogState extends State<_EditAnnotationDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return AlertDialog(
      title: Text(l10n.editAnnotation),
      content: TextField(
        controller: _controller,
        maxLength: 25,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        inputFormatters: [LengthLimitingTextInputFormatter(25)],
        decoration: InputDecoration(
          hintText: l10n.transactionAnnotationHint,
          labelText: l10n.transactionAnnotation,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
