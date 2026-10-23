import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/money/currency.dart';
import '../../../../core/widgets/amount_input_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/icon_helper.dart';
import '../../../../core/widgets/numeric_keypad.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/entities/account_with_balance.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../reports/presentation/providers/reports_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/providers/transactions_providers.dart';
import '../../domain/entities/quick_add_payload.dart';
import '../providers/quick_add_providers.dart';

class QuickAddPage extends ConsumerStatefulWidget {
  final QuickAddPayload payload;

  const QuickAddPage({super.key, required this.payload});

  @override
  ConsumerState<QuickAddPage> createState() => _QuickAddPageState();
}

class _QuickAddPageState extends ConsumerState<QuickAddPage> {
  late TransactionKind _kind;
  String _rawAmount = '';
  int? _selectedAccountId;
  int? _selectedCategoryId;
  final _noteController = TextEditingController();
  bool _isLoading = false;

  static const Color _mintColor = Color(0xFF3B8266);
  static const Color _coralColor = Color(0xFFBC5454);

  @override
  void initState() {
    super.initState();
    _applyPayload(widget.payload);
  }

  @override
  void didUpdateWidget(covariant QuickAddPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.payload != widget.payload) {
      setState(() {
        _applyPayload(widget.payload);
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _applyPayload(QuickAddPayload payload) {
    _kind = payload.kind == TransactionKind.transfer
        ? TransactionKind.expense
        : payload.kind;
    _selectedCategoryId = null;
    _noteController.clear();
    if (payload.amount != null && payload.amount! > 0) {
      _rawAmount = payload.amount.toString();
    } else {
      _rawAmount = '';
    }
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
    setState(() => _rawAmount = '');
  }

  int _computeUnits(Currency currency) {
    final parsed = double.tryParse(_rawAmount) ?? 0.0;
    if (currency.decimals == 0) {
      return parsed.round();
    } else {
      return (parsed * 100).round();
    }
  }

  Category? _resolveSelectedCategory(List<Category> filteredCats) {
    if (filteredCats.isEmpty) return null;
    if (_selectedCategoryId != null) {
      final byId = filteredCats
          .where((c) => c.id == _selectedCategoryId)
          .firstOrNull;
      if (byId != null) return byId;
    }
    if (widget.payload.categoryKey != null &&
        widget.payload.categoryKey!.isNotEmpty) {
      final byKey = filteredCats
          .where((c) => c.key == widget.payload.categoryKey)
          .firstOrNull;
      if (byKey != null) return byKey;
    }
    return filteredCats.first;
  }

  Future<void> _handleSave(
    List<AccountWithBalance> accounts,
    List<Category> filteredCats,
  ) async {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencySettingProvider);
    final amountUnits = _computeUnits(currency);

    if (amountUnits <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.failure_invalidAmount)));
      return;
    }

    if (accounts.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.failure_accountNotFound)));
      return;
    }

    final accountId = _selectedAccountId ?? accounts.first.account.id;
    final category = _resolveSelectedCategory(filteredCats);

    setState(() => _isLoading = true);

    try {
      final addUseCase = ref.read(addTransactionUseCaseProvider);
      final res = await addUseCase(
        kind: _kind,
        amount: amountUnits,
        accountId: accountId,
        categoryId: category?.id,
        occurredAt: DateTime.now(),
        note: _noteController.text.trim(),
      );

      if (res.isOk) {
        HapticFeedback.lightImpact().ignore();
        ref.invalidate(accountsWithBalanceProvider);
        ref.invalidate(safeAvailableProvider);
        ref.invalidate(monthlySummaryProvider);

        // Sync data for Android home widgets (T-080, T-083)
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
          // Widget sync error shouldn't block transaction save
        }

        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.transactionSaved)));
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        }
      } else {
        final f = res.errorOrNull;
        if (f != null && mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(f.toLocalizedMessage(l10n))));
        }
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

    // Watch streams so data is ready immediately even when launched via widget deep-link
    final accountsAsync = ref.watch(accountsWithBalanceProvider);
    final allCatsAsync = ref.watch(allCategoriesProvider);

    final accounts = accountsAsync.asData?.value ?? <AccountWithBalance>[];
    final allCats = allCatsAsync.asData?.value ?? <Category>[];

    final isIncome = _kind == TransactionKind.income;
    final targetCatKind = isIncome ? CategoryKind.income : CategoryKind.expense;
    final filteredCats = allCats
        .where((c) => c.isActive && c.kind == targetCatKind)
        .toList();

    final selectedCategory = _resolveSelectedCategory(filteredCats);
    final selectedAccount =
        accounts
            .where((a) => a.account.id == _selectedAccountId)
            .firstOrNull ??
        accounts.firstOrNull;

    final accentColor = isIncome ? _mintColor : _coralColor;
    final canPopRoute = context.canPop();

    return Scaffold(
      appBar: AppBar(
        leading: canPopRoute
            ? null
            : BackButton(onPressed: () => context.go('/')),
        title: Text(
          l10n.quickAddTitle,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              final kindName = isIncome ? 'income' : 'expense';
              final catKey = selectedCategory?.key;
              final queryParams = <String, String>{'kind': kindName};
              if (catKey != null && catKey.isNotEmpty) {
                queryParams['cat'] = catKey;
              }
              if (_rawAmount.isNotEmpty) {
                final parsed = int.tryParse(_rawAmount);
                if (parsed != null && parsed > 0) {
                  queryParams['amount'] = parsed.toString();
                }
              }
              final noteText = _noteController.text.trim();
              if (noteText.isNotEmpty) {
                queryParams['note'] = noteText;
              }
              final uri = Uri(
                path: '/add-transaction',
                queryParameters: queryParams,
              );
              context.pushReplacement(uri.toString());
            },
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: const Text('Más opciones'),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - 16).clamp(
                    0.0,
                    double.infinity,
                  ),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Minimalist 2-card selector highlighting Entrada vs Salida
                      Row(
                        children: [
                          Expanded(
                            child: _ModePillButton(
                              label: 'Entrada (Ingreso)',
                              icon: Icons.south_west_rounded,
                              activeColor: _mintColor,
                              isSelected: isIncome,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _kind = TransactionKind.income;
                                  _selectedCategoryId = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ModePillButton(
                              label: 'Salida (Gasto)',
                              icon: Icons.north_east_rounded,
                              activeColor: _coralColor,
                              isSelected: !isIncome,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _kind = TransactionKind.expense;
                                  _selectedCategoryId = null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Amount input
                      AmountInputField(
                        rawInput: _rawAmount,
                        currency: currency,
                        color: isIncome ? colors.income : colors.expense,
                      ),

                      // Account selector strip highlighting Efectivo vs Cuenta
                      if (accounts.isNotEmpty) ...[
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: accounts.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final acc = accounts[index].account;
                              final isSelected =
                                  selectedAccount?.account.id == acc.id;
                              final isCash =
                                  acc.type == AccountType.cash ||
                                  acc.name.toLowerCase().contains('efectivo');
                              final badgePrefix =
                                  isCash ? 'Efectivo' : 'Cuenta';
                              final displayLabel =
                                  acc.name.toLowerCase() ==
                                      badgePrefix.toLowerCase()
                                  ? acc.name
                                  : '$badgePrefix • ${acc.name}';

                              return ChoiceChip(
                                avatar: Icon(
                                  isCash
                                      ? Icons.payments_outlined
                                      : Icons.account_balance_outlined,
                                  size: 15,
                                  color: isSelected
                                      ? colors.primary
                                      : colors.onSurfaceMuted,
                                ),
                                label: Text(displayLabel),
                                selected: isSelected,
                                showCheckmark: false,
                                visualDensity: VisualDensity.compact,
                                selectedColor: colors.primary.withValues(
                                  alpha: 0.16,
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? colors.primary
                                      : colors.onSurfaceMuted,
                                ),
                                onSelected: (_) =>
                                    setState(() => _selectedAccountId = acc.id),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      if (filteredCats.isNotEmpty) ...[
                        SizedBox(
                          height: 40,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: filteredCats.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final cat = filteredCats[index];
                              final isSelected = selectedCategory?.id == cat.id;
                              final catColor = Color(cat.color);
                              final name = cat.displayName(
                                (k) => l10n.translateCategoryKey(k),
                              );
                              return InkWell(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _selectedCategoryId = cat.id);
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? catColor.withValues(alpha: 0.18)
                                        : colors.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? catColor
                                          : colors.outline.withValues(
                                              alpha: 0.35,
                                            ),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        getIconData(cat.icon),
                                        size: 16,
                                        color: catColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: colors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      const Spacer(),
                      const SizedBox(height: 8),

                      TextField(
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
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      NumericKeypad(
                        currency: currency,
                        onDigit: _onDigit,
                        onBackspace: _onBackspace,
                        onClear: _onClear,
                      ),
                      const SizedBox(height: 14),
                      AppButton(
                        label: l10n.save,
                        isLoading: _isLoading,
                        icon: Icons.check_circle_rounded,
                        backgroundColor: accentColor,
                        onPressed: () => _handleSave(accounts, filteredCats),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ModePillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color activeColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModePillButton({
    required this.label,
    required this.icon,
    required this.activeColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSelected ? activeColor : colors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? activeColor
                  : colors.outline.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : activeColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: activeColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : colors.onSurface,
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
