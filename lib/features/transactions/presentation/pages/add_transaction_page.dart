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
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../quick_add/presentation/providers/quick_add_providers.dart';
import '../../../reports/presentation/providers/reports_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transactions_providers.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  final TransactionKind initialKind;
  final String? initialCategoryKey;
  final int? initialAmountUnits;
  final String? initialNote;

  const AddTransactionPage({
    super.key,
    this.initialKind = TransactionKind.expense,
    this.initialCategoryKey,
    this.initialAmountUnits,
    this.initialNote,
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

  static const Color _mintColor = Color(0xFF3B8266);
  static const Color _coralColor = Color(0xFFBC5454);
  static const Color _skyBlueColor = Color(0xFF4A7C9B);

  @override
  void initState() {
    super.initState();
    _kind = widget.initialKind;
    if (widget.initialAmountUnits != null && widget.initialAmountUnits! > 0) {
      _rawAmount = widget.initialAmountUnits.toString();
    }
    if (widget.initialNote != null && widget.initialNote!.isNotEmpty) {
      _noteController.text = widget.initialNote!;
    }
  }

  @override
  void didUpdateWidget(covariant AddTransactionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialKind != widget.initialKind ||
        oldWidget.initialCategoryKey != widget.initialCategoryKey ||
        oldWidget.initialAmountUnits != widget.initialAmountUnits ||
        oldWidget.initialNote != widget.initialNote) {
      setState(() {
        _kind = widget.initialKind;
        _selectedCategory = null;
        if (widget.initialAmountUnits != null &&
            widget.initialAmountUnits! > 0) {
          _rawAmount = widget.initialAmountUnits.toString();
        }
        if (widget.initialNote != null) {
          _noteController.text = widget.initialNote!;
        }
      });
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

  Future<void> _syncWidgetData() async {
    ref.invalidate(accountsWithBalanceProvider);
    ref.invalidate(safeAvailableProvider);
    ref.invalidate(monthlySummaryProvider);
    try {
      final now = DateTime.now();
      final safeRes = await ref.read(computeSafeAvailableUseCaseProvider)();
      final summaryRes = await ref.read(getMonthlySummaryUseCaseProvider)(
        year: now.year,
        month: now.month,
      );

      final safeAvail = safeRes.valueOrNull?.safeAvailable ?? 0;
      final monthlyBal = summaryRes.valueOrNull?.balance ?? 0;

      final updateWidgetData = ref.read(updateWidgetDataUseCaseProvider);
      await updateWidgetData(
        safeAvailable: safeAvail,
        monthlyBalance: monthlyBal,
      );
    } catch (_) {
      // Ignore widget sync errors
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

        await res.fold(
          onOk: (_) async {
            HapticFeedback.lightImpact().ignore();
            await _syncWidgetData();
            if (!mounted) return;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.transactionSaved)));
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          onError: (failure) async {
            if (!mounted) return;
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

        await res.fold(
          onOk: (_) async {
            HapticFeedback.lightImpact().ignore();
            await _syncWidgetData();
            if (!mounted) return;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.transactionSaved)));
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          onError: (failure) async {
            if (!mounted) return;
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

  String _formatAccountWithKind(Account acc, String formattedBalance) {
    final isCash =
        acc.type == AccountType.cash ||
        acc.name.toLowerCase().contains('efectivo');
    final typeTag = isCash ? 'Efectivo' : 'Cuenta';
    if (acc.name.toLowerCase() == typeTag.toLowerCase()) {
      return '${acc.name} ($formattedBalance)';
    }
    return '[$typeTag] ${acc.name} ($formattedBalance)';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencySettingProvider);
    final accountsAsync = ref.watch(accountsWithBalanceProvider);
    final expenseCatsAsync = ref.watch(activeExpenseCategoriesProvider);
    final incomeCatsAsync = ref.watch(activeIncomeCategoriesProvider);

    // Auto-select valid source & target accounts
    accountsAsync.whenData((accounts) {
      if (accounts.isNotEmpty &&
          (_selectedAccountId == null ||
              !accounts.any((a) => a.account.id == _selectedAccountId))) {
        _selectedAccountId = accounts.first.account.id;
      }
      if (_kind == TransactionKind.transfer) {
        final validTargets = accounts
            .where((a) => a.account.id != _selectedAccountId)
            .toList();
        if (validTargets.isEmpty) {
          _selectedToAccountId = null;
        } else if (_selectedToAccountId == null ||
            !validTargets.any((a) => a.account.id == _selectedToAccountId)) {
          _selectedToAccountId = validTargets.first.account.id;
        }
      }
    });

    final currentCatsAsync = _kind == TransactionKind.income
        ? incomeCatsAsync
        : expenseCatsAsync;

    // Auto-select initial category if matching key or default first category
    currentCatsAsync.whenData((cats) {
      if (_selectedCategory == null && cats.isNotEmpty) {
        if (widget.initialCategoryKey != null) {
          final match = cats.where((c) => c.key == widget.initialCategoryKey);
          if (match.isNotEmpty) {
            _selectedCategory = match.first;
            return;
          }
        }
        _selectedCategory = cats.first;
      }
    });

    final accentColor = _kind == TransactionKind.income
        ? _mintColor
        : _kind == TransactionKind.expense
        ? _coralColor
        : _skyBlueColor;
    final canPopRoute = context.canPop();

    return Scaffold(
      appBar: AppBar(
        leading: canPopRoute
            ? null
            : BackButton(onPressed: () => context.go('/')),
        title: Text(l10n.addTransactionTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Minimalist Kind Toggle highlighting Salida vs Entrada vs Transferencia
              Row(
                children: [
                  _kindButton(
                    label: 'Salida (${l10n.transactionExpense})',
                    icon: Icons.north_east_rounded,
                    kind: TransactionKind.expense,
                    selected: _kind == TransactionKind.expense,
                    activeColor: _coralColor,
                  ),
                  const SizedBox(width: 8),
                  _kindButton(
                    label: 'Entrada (${l10n.transactionIncome})',
                    icon: Icons.south_west_rounded,
                    kind: TransactionKind.income,
                    selected: _kind == TransactionKind.income,
                    activeColor: _mintColor,
                  ),
                  const SizedBox(width: 8),
                  _kindButton(
                    label: l10n.transactionTransfer,
                    icon: Icons.swap_horiz_rounded,
                    kind: TransactionKind.transfer,
                    selected: _kind == TransactionKind.transfer,
                    activeColor: _skyBlueColor,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Amount display
              AmountInputField(
                rawInput: _rawAmount,
                currency: currency,
                color: _kind == TransactionKind.income
                    ? colors.income
                    : _kind == TransactionKind.expense
                    ? colors.expense
                    : colors.primary,
              ),

              // Accounts selector highlighting Efectivo vs Cuenta
              accountsAsync.when(
                data: (accounts) {
                  final targetAccounts = accounts
                      .where((a) => a.account.id != _selectedAccountId)
                      .toList();
                  final effectiveToAccountId =
                      targetAccounts.any(
                        (a) => a.account.id == _selectedToAccountId,
                      )
                      ? _selectedToAccountId
                      : targetAccounts.firstOrNull?.account.id;

                  return Column(
                    children: [
                      DropdownButtonFormField<int>(
                        key: ValueKey('src_acc_$_selectedAccountId'),
                        isExpanded: true,
                        initialValue: _selectedAccountId,
                        decoration: InputDecoration(
                          labelText: _kind == TransactionKind.transfer
                              ? l10n.transactionSourceAccount
                              : '${l10n.transactionAccount} (Efectivo / Cuenta)',
                        ),
                        items: accounts.map((item) {
                          final acc = item.account;
                          return DropdownMenuItem<int>(
                            value: acc.id,
                            child: Text(
                              _formatAccountWithKind(
                                acc,
                                item.balance.format(),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedAccountId = val;
                            if (_selectedToAccountId == val) {
                              _selectedToAccountId = accounts
                                  .where((a) => a.account.id != val)
                                  .firstOrNull
                                  ?.account
                                  .id;
                            }
                          });
                        },
                      ),
                      if (_kind == TransactionKind.transfer) ...[
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          key: ValueKey(
                            'dst_acc_${_selectedAccountId}_$effectiveToAccountId',
                          ),
                          isExpanded: true,
                          initialValue: effectiveToAccountId,
                          decoration: InputDecoration(
                            labelText: l10n.transactionTargetAccount,
                          ),
                          items: targetAccounts.map((item) {
                            final acc = item.account;
                            return DropdownMenuItem<int>(
                              value: acc.id,
                              child: Text(
                                _formatAccountWithKind(
                                  acc,
                                  item.balance.format(),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
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
                      maxLength: 25,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(25),
                      ],
                      decoration: InputDecoration(
                        hintText: l10n.transactionAnnotationHint,
                        prefixIcon: const Icon(
                          Icons.sticky_note_2_outlined,
                          size: 16,
                        ),
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
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
    required IconData icon,
    required TransactionKind kind,
    required bool selected,
    required Color activeColor,
  }) {
    final colors = context.colors;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _kind = kind;
            _selectedCategory = null;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? activeColor : colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? activeColor
                  : colors.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white
                      : activeColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: activeColor),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: selected ? Colors.white : colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
