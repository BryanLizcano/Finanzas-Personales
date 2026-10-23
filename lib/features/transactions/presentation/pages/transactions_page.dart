import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../core/widgets/transaction_tile.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../accounts/domain/entities/account_with_balance.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transactions_providers.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  TransactionKind? _selectedKind;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencySettingProvider);
    final locale = Localizations.localeOf(context).languageCode;

    final filter = TransactionFilter(
      kind: _selectedKind,
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
    );

    final txAsync = ref.watch(transactionsStreamProvider(filter));
    final accountsAsync = ref.watch(accountsWithBalanceProvider);
    final allCatsAsync = ref.watch(allCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navTransactions)),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: colors.primary,
                      ),
                      hintText: l10n.transactionSearchPlaceholder,
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() => _searchQuery = val.trim());
                    },
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _filterChip(
                          label: l10n.transactionFilterAll,
                          isSelected: _selectedKind == null,
                          onSelected: () =>
                              setState(() => _selectedKind = null),
                        ),
                        const SizedBox(width: 8),
                        _filterChip(
                          label: 'Salidas (${l10n.transactionFilterExpense})',
                          isSelected: _selectedKind == TransactionKind.expense,
                          onSelected: () => setState(
                            () => _selectedKind = TransactionKind.expense,
                          ),
                          activeColor: colors.expense,
                        ),
                        const SizedBox(width: 8),
                        _filterChip(
                          label: 'Entradas (${l10n.transactionFilterIncome})',
                          isSelected: _selectedKind == TransactionKind.income,
                          onSelected: () => setState(
                            () => _selectedKind = TransactionKind.income,
                          ),
                          activeColor: colors.income,
                        ),
                        const SizedBox(width: 8),
                        _filterChip(
                          label: l10n.transactionFilterTransfer,
                          isSelected: _selectedKind == TransactionKind.transfer,
                          onSelected: () => setState(
                            () => _selectedKind = TransactionKind.transfer,
                          ),
                          activeColor: colors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Transactions list
            Expanded(
              child: txAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return EmptyStateWidget(
                      title: l10n.transactionEmpty,
                      subtitle: l10n.transactionEmptySubtitle,
                      actionLabel: l10n.navAdd,
                      onAction: () => context.push('/add-transaction'),
                    );
                  }

                  // Group transactions by day
                  final groups = <String, List<TransactionEntity>>{};
                  final now = DateTime.now();
                  final todayStr = DateFormat.yMd(locale).format(now);
                  final yesterdayStr = DateFormat.yMd(locale)
                      .format(now.subtract(const Duration(days: 1)));

                  for (final tx in transactions) {
                    final txDateStr = DateFormat.yMd(locale)
                        .format(tx.occurredAt);
                    String header;
                    if (txDateStr == todayStr) {
                      header = locale == 'en' ? 'Today' : 'Hoy';
                    } else if (txDateStr == yesterdayStr) {
                      header = locale == 'en' ? 'Yesterday' : 'Ayer';
                    } else {
                      header = DateFormat.yMMMMd(locale).format(tx.occurredAt);
                    }
                    groups.putIfAbsent(header, () => []).add(tx);
                  }

                  final accounts =
                      accountsAsync.asData?.value ?? <AccountWithBalance>[];
                  final categories = allCatsAsync.asData?.value ?? <Category>[];

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: groups.keys.length,
                    itemBuilder: (context, index) {
                      final header = groups.keys.elementAt(index);
                      final dayTxs = groups[header]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4,
                            ),
                            child: Text(
                              header,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.onSurfaceMuted,
                                  ),
                            ),
                          ),
                          ...dayTxs.map((tx) {
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
                                categoryColor: cat != null
                                    ? Color(cat.color)
                                    : null,
                                accountName: acc?.account.name,
                                accountType: acc?.account.type,
                                toAccountName: toAcc?.account.name,
                                toAccountType: toAcc?.account.type,
                                onDismissed: () async {
                                  // Soft delete
                                  final deleteTx = ref.read(
                                    deleteTransactionUseCaseProvider,
                                  );
                                  await deleteTx(tx.id);

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text(l10n.transactionDeleted),
                                          action: SnackBarAction(
                                            label: l10n.undo,
                                            onPressed: () {
                                              ref.read(
                                                restoreTransactionUseCaseProvider,
                                              )(tx.id);
                                            },
                                          ),
                                        ),
                                      );
                                  }
                                },
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SkeletonList(itemCount: 6),
                ),
                error: (err, _) => ErrorStateWidget(
                  customMessage: err.toString(),
                  onRetry: () =>
                      ref.refresh(transactionsStreamProvider(filter)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    Color? activeColor,
  }) {
    final colors = context.colors;
    final effColor = activeColor ?? colors.primary;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      labelStyle: TextStyle(
        color: isSelected ? colors.onPrimary : colors.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: colors.surface,
      selectedColor: effColor,
      side: BorderSide(
        color: isSelected ? effColor : colors.outline.withValues(alpha: 0.5),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
