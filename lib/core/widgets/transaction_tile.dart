import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/finance_colors.dart';
import '../../features/accounts/domain/entities/account.dart';
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
  final AccountType? accountType;
  final String? toAccountName;
  final AccountType? toAccountType;
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
    this.accountType,
    this.toAccountName,
    this.toAccountType,
    this.onTap,
    this.onDismissed,
  });

  bool _isCash(AccountType? type, String? name) {
    if (type != null) {
      return type == AccountType.cash;
    }
    final lower = (name ?? '').toLowerCase();
    return lower.contains('efectivo') ||
        lower.contains('cash') ||
        lower.contains('billetera');
  }

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

    // 1. Movement badge (Entrada vs Salida vs Transferencia)
    final String flowLabel = isIncome
        ? 'Entrada'
        : isExpense
        ? 'Salida'
        : 'Transferencia';
    final IconData flowIcon = isIncome
        ? Icons.south_west_rounded
        : isExpense
        ? Icons.north_east_rounded
        : Icons.swap_horiz_rounded;

    // 2. Account / Payment Method badge (Efectivo vs Cuenta)
    final bool sourceIsCash = _isCash(accountType, accountName);
    final String mediumTypeLabel = sourceIsCash ? 'Efectivo' : 'Cuenta';
    final IconData mediumIcon = sourceIsCash
        ? Icons.payments_outlined
        : Icons.account_balance_outlined;
    final Color mediumColor = sourceIsCash ? colors.savings : colors.primary;

    final String accountDisplayText;
    if (isTransfer) {
      final from = accountName ?? l10n.transactionSourceAccount;
      final to = toAccountName ?? l10n.transactionTargetAccount;
      accountDisplayText = '$from → $to';
    } else if (accountName != null && accountName!.isNotEmpty) {
      final lowerAcc = accountName!.toLowerCase();
      if (lowerAcc == 'efectivo' || lowerAcc == 'cuenta') {
        accountDisplayText = mediumTypeLabel;
      } else {
        accountDisplayText = '$mediumTypeLabel • $accountName';
      }
    } else {
      accountDisplayText = mediumTypeLabel;
    }

    final effectiveIcon = isTransfer
        ? Icons.swap_horiz_rounded
        : getIconData(iconName);
    final effectiveColor = isTransfer
        ? colors.primary
        : categoryColor ?? amountColor;

    final tileBody = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Subtle vertical color bar highlighting Entrada / Salida
            Container(
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                color: amountColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            // Category icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: effectiveColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(effectiveIcon, color: effectiveColor, size: 21),
            ),
            const SizedBox(width: 12),
            // Title, Badges (Entrada/Salida + Efectivo/Cuenta) & optional note
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isTransfer ? l10n.transactionTransfer : categoryTitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Badge 1: Entrada / Salida
                      _HighlightBadge(
                        icon: flowIcon,
                        label: flowLabel,
                        color: amountColor,
                      ),
                      // Badge 2: Efectivo / Cuenta
                      _HighlightBadge(
                        icon: mediumIcon,
                        label: accountDisplayText,
                        color: mediumColor,
                      ),
                    ],
                  ),
                  if (!isTransfer && transaction.note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      transaction.note,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceMuted,
                        fontSize: 11.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Amount & Date
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$sign${money.format(locale)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(transaction.occurredAt),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
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
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(Icons.delete_rounded, color: colors.onPrimary),
        ),
        onDismissed: (_) => onDismissed!(),
        child: Card(child: tileBody),
      );
    }

    return Card(child: tileBody);
  }
}

class _HighlightBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _HighlightBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.28),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.5, color: color),
          const SizedBox(width: 3.5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 135),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
