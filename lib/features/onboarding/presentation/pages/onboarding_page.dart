import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/money/currency.dart';
import '../../../../core/money/money.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/presentation/providers/accounts_providers.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  Currency _selectedCurrency = Currency.cop;
  final _baseIncomeController = TextEditingController();
  final _accountNameController = TextEditingController(text: 'Efectivo');
  final _initialBalanceController = TextEditingController(text: '0');
  AccountType _accountType = AccountType.cash;
  bool _isLoading = false;

  @override
  void dispose() {
    _baseIncomeController.dispose();
    _accountNameController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  Future<void> _handleStart() async {
    setState(() => _isLoading = true);
    try {
      // 1. Set selected currency
      await ref
          .read(currencySettingProvider.notifier)
          .setCurrency(_selectedCurrency);

      // 2. Set base income if entered
      final baseIncomeMajor =
          int.tryParse(_baseIncomeController.text.trim()) ?? 0;
      if (baseIncomeMajor > 0) {
        final baseIncomeMoney = Money.fromMajor(
          baseIncomeMajor,
          _selectedCurrency,
        );
        final setBaseIncome = ref.read(setBaseIncomeUseCaseProvider);
        await setBaseIncome(baseIncomeMoney.units);
      }

      // 3. Create initial account
      final accName = _accountNameController.text.trim().isEmpty
          ? 'Principal'
          : _accountNameController.text.trim();
      final initBalMajor =
          int.tryParse(_initialBalanceController.text.trim()) ?? 0;
      final initBalMoney = Money.fromMajor(initBalMajor, _selectedCurrency);

      final createAccount = ref.read(createAccountUseCaseProvider);
      await createAccount(
        name: accName,
        type: _accountType,
        initialBalance: initBalMoney.units,
      );

      // 4. Complete onboarding
      await ref.read(onboardingCompletedProvider.notifier).completeOnboarding();

      if (mounted) {
        context.go('/');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: colors.primary,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.onboardingTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.onboardingSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: colors.onSurfaceMuted),
                ),
                const SizedBox(height: 32),

                // Step 1: Currency selection
                Text(
                  l10n.onboardingStepCurrency,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: Currency.values.map((cur) {
                    final isSel = _selectedCurrency == cur;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: OutlinedButton(
                          onPressed: () =>
                              setState(() => _selectedCurrency = cur),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isSel
                                ? colors.primary.withValues(alpha: 0.12)
                                : colors.surface,
                            side: BorderSide(
                              color: isSel ? colors.primary : colors.outline,
                              width: isSel ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            cur.code,
                            style: TextStyle(
                              color: isSel ? colors.primary : colors.onSurface,
                              fontWeight: isSel
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Step 2: Base income
                Text(
                  l10n.onboardingStepBaseIncome,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.onboardingStepBaseIncomeHelp,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: colors.onSurfaceMuted),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _baseIncomeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.attach_money_rounded,
                      color: colors.primary,
                    ),
                    hintText: '1500000',
                  ),
                ),
                const SizedBox(height: 24),

                // Step 3: Initial account
                Text(
                  l10n.onboardingStepAccount,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _accountNameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.wallet_rounded,
                      color: colors.primary,
                    ),
                    labelText: l10n.accountName,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<AccountType>(
                        initialValue: _accountType,
                        decoration: InputDecoration(
                          labelText: l10n.accountType,
                        ),
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
                          if (val != null) setState(() => _accountType = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _initialBalanceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.accountInitialBalance,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                AppButton(
                  label: l10n.onboardingStartButton,
                  isLoading: _isLoading,
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: _handleStart,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
