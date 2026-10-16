import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/finance_colors.dart';
import '../../features/transactions/domain/entities/transaction.dart';
import '../../l10n/generated/app_localizations.dart';
import '../money/currency.dart';
import '../money/money.dart';
import 'icon_helper.dart';

class TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;
  final Currency currency;
  final String categoryTitle;
  final String? iconName;
  final Color? categoryColor;
  final String? accountName;
  final String? toAccountName;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.currency,
    required this.categoryTitle,
    this.iconName,
    this.categoryColor,
    this.accountName,
    this.toAccountName,
    this.onTap,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat.MMMd(locale);

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

    Widget subtitleWidget;
    if (isTransfer) {
      final from = accountName ?? l10n.transactionSourceAccount;
      final to = toAccountName ?? l10n.transactionTargetAccount;
      subtitleWidget = Text(
        '$from -> $to',
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: colors.onSurfaceMuted),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      final details = <String>[];
      if (accountName != null) details.add(accountName!);
      if (transaction.note.isNotEmpty) details.add(transaction.note);
      subtitleWidget = Text(
        details.join(' • '),
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: colors.onSurfaceMuted),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final effectiveIcon = isTransfer
        ? Icons.swap_horiz_rounded
        : getIconData(iconName);
    final effectiveColor = isTransfer
        ? colors.primary
        : categoryColor ?? colors.primary;

    final content = ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: effectiveColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(effectiveIcon, color: effectiveColor, size: 22),
      ),
      title: Text(
        isTransfer ? l10n.transactionTransfer : categoryTitle,
        style: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitleWidget,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$sign${money.format(locale)}',
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: amountColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            dateFormat.format(transaction.occurredAt),
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: colors.onSurfaceMuted),
          ),
        ],
      ),
    );

    if (onDismissed != null) {
      return Dismissible(
        key: Key('tx_${transaction.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: colors.expense,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.delete_rounded, color: colors.onPrimary),
        ),
        onDismissed: (_) => onDismissed!(),
        child: Card(child: content),
      );
    }

    return Card(child: content);
  }
}
