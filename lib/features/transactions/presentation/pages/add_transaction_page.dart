import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/money/currency.dart';
import '../../../../core/widgets/amount_input_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/numeric_keypad.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transactions_providers.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  final TransactionKind initialKind;
  final String? initialCategoryKey;
  final int? initialAmountUnits;

  const AddTransactionPage({
    super.key,
    this.initialKind = TransactionKind.expense,
    this.initialCategoryKey,
    this.initialAmountUnits,
  });

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  late TransactionKind _kind;
  String _rawAmount = '';
  int? _selectedAccountId;
  int? _selectedToAccountId;
  Category? _selectedCategory;
  DateTime _occurredAt = DateTime.now();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _kind = widget.initialKind;
    if (widget.initialAmountUnits != null && widget.initialAmountUnits! > 0) {
      _rawAmount = widget.initialAmountUnits.toString();
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onDigit(String digit) {
    if (_rawAmount.length >= 10) return;
    setState(() {
      if (_rawAmount == '0' && digit != '.') {
        _rawAmount = digit;
      } else {
        _rawAmount += digit;
      }
    });
  }

  void _onBackspace() {
    if (_rawAmount.isEmpty) return;
    setState(() {
      _rawAmount = _rawAmount.substring(0, _rawAmount.length - 1);
    });
  }

  void _onClear() {
    setState(() {
      _rawAmount = '';
    });
  }

  int _computeUnits(Currency currency) {
    final parsed = double.tryParse(_rawAmount) ?? 0.0;
    if (currency.decimals == 0) {
      return parsed.round();
    } else {
      return (parsed * 100).round();
    }
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencySettingProvider);
    final amountUnits = _computeUnits(currency);

    if (amountUnits <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.failure_invalidAmount)));
      return;
    }

    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.selectAccount)));
      return;
    }

    if (_kind != TransactionKind.transfer && _selectedCategory == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.selectCategory)));
      return;
    }

    if (_kind == TransactionKind.transfer &&
        (_selectedToAccountId == null ||
            _selectedToAccountId == _selectedAccountId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.failure_invalidTransferSameAccount)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_kind == TransactionKind.transfer) {
        final transferUseCase = ref.read(
          transferBetweenAccountsUseCaseProvider,
        );
        final res = await transferUseCase(
          sourceAccountId: _selectedAccountId!,
          targetAccountId: _selectedToAccountId!,
          amount: amountUnits,
          occurredAt: _occurredAt,
          note: _noteController.text.trim(),
        );

        res.fold(
          onOk: (_) {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.transactionSaved)));
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          onError: (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.toLocalizedMessage(l10n))),
            );
          },
        );
      } else {
        final addUseCase = ref.read(addTransactionUseCaseProvider);
        final res = await addUseCase(
          kind: _kind,
          amount: amountUnits,
          accountId: _selectedAccountId!,
          categoryId: _selectedCategory?.id,
          occurredAt: _occurredAt,
          note: _noteController.text.trim(),
        );

        res.fold(
          onOk: (_) {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.transactionSaved)));
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          onError: (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.toLocalizedMessage(l10n))),
            );
          },
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencySettingProvider);
    final accountsAsync = ref.watch(accountsWithBalanceProvider);
    final expenseCatsAsync = ref.watch(activeExpenseCategoriesProvider);
    final incomeCatsAsync = ref.watch(activeIncomeCategoriesProvider);

    // Auto-select first account if not selected
    accountsAsync.whenData((accounts) {
      if (_selectedAccountId == null && accounts.isNotEmpty) {
        _selectedAccountId = accounts.first.account.id;
      }
    });

    final currentCatsAsync = _kind == TransactionKind.income
        ? incomeCatsAsync
        : expenseCatsAsync;

    // Auto-select initial category if matching key
    if (_selectedCategory == null && widget.initialCategoryKey != null) {
      currentCatsAsync.whenData((cats) {
        final match = cats.where((c) => c.key == widget.initialCategoryKey);
        if (match.isNotEmpty) {
          _selectedCategory = match.first;
        }
      });
    }

    final accentColor = _kind == TransactionKind.income
        ? colors.income
        : _kind == TransactionKind.expense
        ? colors.expense
        : colors.primary;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addTransactionTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kind toggle
              Container(
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _kindButton(
                      label: l10n.transactionExpense,
                      kind: TransactionKind.expense,
                      selected: _kind == TransactionKind.expense,
                      activeColor: colors.expense,
                    ),
                    _kindButton(
                      label: l10n.transactionIncome,
                      kind: TransactionKind.income,
                      selected: _kind == TransactionKind.income,
                      activeColor: colors.income,
                    ),
                    _kindButton(
                      label: l10n.transactionTransfer,
                      kind: TransactionKind.transfer,
                      selected: _kind == TransactionKind.transfer,
                      activeColor: colors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Amount display
              AmountInputField(
                rawInput: _rawAmount,
                currency: currency,
                color: accentColor,
              ),

              // Accounts selector
              accountsAsync.when(
                data: (accounts) {
                  return Column(
                    children: [
                      DropdownButtonFormField<int>(
                        initialValue: _selectedAccountId,
                        decoration: InputDecoration(
                          labelText: _kind == TransactionKind.transfer
                              ? l10n.transactionSourceAccount
                              : l10n.transactionAccount,
                        ),
                        items: accounts.map((item) {
                          final acc = item.account;
                          return DropdownMenuItem<int>(
                            value: acc.id,
                            child: Text(
                              '${acc.name} (${item.balance.format()})',
                            ),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => _selectedAccountId = val),
                      ),
                      if (_kind == TransactionKind.transfer) ...[
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          initialValue: _selectedToAccountId,
                          decoration: InputDecoration(
                            labelText: l10n.transactionTargetAccount,
                          ),
                          items: accounts
                              .where((a) => a.account.id != _selectedAccountId)
                              .map((item) {
                                final acc = item.account;
                                return DropdownMenuItem<int>(
                                  value: acc.id,
                                  child: Text(
                                    '${acc.name} (${item.balance.format()})',
                                  ),
                                );
                              })
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedToAccountId = val),
                        ),
                      ],
                    ],
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),

              // Categories grid (if not transfer)
              if (_kind != TransactionKind.transfer) ...[
                Text(
                  l10n.transactionCategory,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                currentCatsAsync.when(
                  data: (categories) {
                    return SizedBox(
                      height: 160,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: categories.length,
                        itemBuilder: (context, i) {
                          final cat = categories[i];
                          final isSel = _selectedCategory?.id == cat.id;
                          final displayName = cat.displayName(
                            (k) => l10n.translateCategoryKey(k),
                          );
                          return CategoryChip(
                            title: displayName,
                            icon: cat.icon,
                            color: Color(cat.color),
                            isSelected: isSel,
                            onTap: () =>
                                setState(() => _selectedCategory = cat),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const SizedBox(height: 120),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 12),
              ],

              // Date & Note in a row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _occurredAt,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) {
                          setState(() => _occurredAt = picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today_rounded, size: 16),
                      label: Text(
                        DateFormat.yMMMd(
                          Localizations.localeOf(context).languageCode,
                        ).format(_occurredAt),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: l10n.transactionNote,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Numeric keypad
              NumericKeypad(
                currency: currency,
                onDigit: _onDigit,
                onBackspace: _onBackspace,
                onClear: _onClear,
              ),
              const SizedBox(height: 16),

              // Save button
              AppButton(
                label: l10n.save,
                isLoading: _isLoading,
                icon: Icons.check_rounded,
                backgroundColor: accentColor,
                onPressed: _handleSave,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kindButton({
    required String label,
    required TransactionKind kind,
    required bool selected,
    required Color activeColor,
  }) {
    final colors = context.colors;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _kind = kind;
            _selectedCategory = null;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colors.outline.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? activeColor : colors.onSurfaceMuted,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
