import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/money/currency.dart';
import '../../../../core/widgets/amount_input_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/numeric_keypad.dart';
import '../../../../l10n/generated/app_localizations.dart';
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
  String _rawAmount = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.payload.amount != null && widget.payload.amount! > 0) {
      _rawAmount = widget.payload.amount.toString();
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

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencySettingProvider);
    final amountUnits = _computeUnits(currency);

    if (amountUnits <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.failure_invalidAmount)));
      return;
    }

    final accounts =
        ref.read(accountsWithBalanceProvider).asData?.value ??
        <AccountWithBalance>[];
    if (accounts.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.failure_accountNotFound)));
      return;
    }

    final defaultAccount = accounts.first.account;

    // Find category matching payload categoryKey
    final allCats =
        ref.read(allCategoriesProvider).asData?.value ?? <Category>[];
    final category = allCats
        .where((Category c) => c.key == widget.payload.categoryKey)
        .firstOrNull;

    setState(() => _isLoading = true);

    try {
      final addUseCase = ref.read(addTransactionUseCaseProvider);
      final res = await addUseCase(
        kind: widget.payload.kind,
        amount: amountUnits,
        accountId: defaultAccount.id,
        categoryId: category?.id,
        occurredAt: DateTime.now(),
        note: 'Quick Add',
      );

      if (res.isOk) {
        await HapticFeedback.lightImpact();

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

    final isIncome = widget.payload.kind == TransactionKind.income;
    final accentColor = isIncome ? colors.income : colors.expense;
    final catKey = widget.payload.categoryKey ?? '';
    final categoryName = catKey.isNotEmpty
        ? l10n.translateCategoryKey(catKey)
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${l10n.quickAddTitle}${categoryName.isNotEmpty ? ' • $categoryName' : ''}',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              AmountInputField(
                rawInput: _rawAmount,
                currency: currency,
                color: accentColor,
              ),
              const Spacer(),
              NumericKeypad(
                currency: currency,
                onDigit: _onDigit,
                onBackspace: _onBackspace,
                onClear: _onClear,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: l10n.save,
                isLoading: _isLoading,
                icon: Icons.check_circle_rounded,
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
}
