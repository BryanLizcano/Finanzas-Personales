import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/money/currency.dart';
import '../../../../core/money/money.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../budget/domain/entities/allocation_rule.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../data/repositories/settings_repository.dart';
import '../providers/settings_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    final currentTheme = ref.watch(themeSettingProvider);
    final currentLang = ref.watch(languageSettingProvider);
    final currentCurrency = ref.watch(currencySettingProvider);

    final baseIncomeAsync = ref.watch(baseIncomeStreamProvider);
    final rulesAsync = ref.watch(allocationRulesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Section: Appearance
          _sectionHeader(l10n.settingsAppearance, context),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.palette_outlined, color: colors.primary),
                  title: Text(l10n.settingsTheme),
                  subtitle: Text(_themeLabel(currentTheme, l10n)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showThemeDialog(context, ref, currentTheme),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.language_rounded, color: colors.primary),
                  title: Text(l10n.settingsLanguage),
                  subtitle: Text(_languageLabel(currentLang, l10n)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showLanguageDialog(context, ref, currentLang),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.monetization_on_outlined,
                    color: colors.primary,
                  ),
                  title: Text(l10n.settingsCurrency),
                  subtitle: Text(currentCurrency.code),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () =>
                      _showCurrencyDialog(context, ref, currentCurrency),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Budget & Allocation
          _sectionHeader(l10n.settingsBudgetAndRules, context),
          Card(
            child: Column(
              children: [
                baseIncomeAsync.when(
                  data: (baseIncome) {
                    final money = Money(
                      units: baseIncome,
                      currency: currentCurrency,
                    );
                    return ListTile(
                      leading: Icon(
                        Icons.savings_outlined,
                        color: colors.savings,
                      ),
                      title: Text(l10n.settingsBaseIncome),
                      subtitle: Text(money.format()),
                      trailing: const Icon(Icons.edit_rounded, size: 18),
                      onTap: () => _showBaseIncomeDialog(
                        context,
                        ref,
                        baseIncome,
                        currentCurrency,
                      ),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const Divider(height: 1),
                rulesAsync.when(
                  data: (rules) {
                    final debtRule =
                        rules
                            .where((r) => r.target == AllocationTarget.debts)
                            .firstOrNull
                            ?.percent ??
                        50;
                    final savingsRule =
                        rules
                            .where((r) => r.target == AllocationTarget.savings)
                            .firstOrNull
                            ?.percent ??
                        20;
                    final freeRule =
                        rules
                            .where((r) => r.target == AllocationTarget.free)
                            .firstOrNull
                            ?.percent ??
                        30;

                    return ListTile(
                      leading: Icon(
                        Icons.pie_chart_outline_rounded,
                        color: colors.primary,
                      ),
                      title: Text(l10n.settingsAllocationRules),
                      subtitle: Text(
                        '$debtRule% deudas / $savingsRule% ahorro / $freeRule% libre',
                      ),
                      trailing: const Icon(Icons.edit_rounded, size: 18),
                      onTap: () => _showAllocationDialog(
                        context,
                        ref,
                        debtRule,
                        savingsRule,
                        freeRule,
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Management & Features
          _sectionHeader('Administración', context),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: colors.primary,
                  ),
                  title: Text(l10n.accountsTitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/accounts'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.category_outlined, color: colors.primary),
                  title: Text(l10n.categoriesTitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/categories'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.savings_outlined, color: colors.savings),
                  title: Text(l10n.savingsTitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/savings'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.backup_outlined, color: colors.primary),
                  title: Text(l10n.settingsBackup),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/backup'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.system_update_rounded,
                    color: colors.primary,
                  ),
                  title: Text(l10n.settingsUpdates),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/updates'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: About
          Card(
            color: colors.primary.withValues(alpha: 0.06),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsAbout,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.settingsVersion}: 1.2.1 (Offline-First)',
                    style: TextStyle(
                      color: colors.onSurfaceMuted,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.settingsOfflineNotice,
                    style: TextStyle(
                      color: colors.onSurfaceMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.colors.onSurfaceMuted,
        ),
      ),
    );
  }

  String _themeLabel(AppThemeSetting theme, AppLocalizations l10n) {
    switch (theme) {
      case AppThemeSetting.system:
        return l10n.settingsThemeSystem;
      case AppThemeSetting.light:
        return l10n.settingsThemeLight;
      case AppThemeSetting.dark:
        return l10n.settingsThemeDark;
    }
  }

  String _languageLabel(AppLanguageSetting lang, AppLocalizations l10n) {
    switch (lang) {
      case AppLanguageSetting.system:
        return l10n.settingsLanguageSystem;
      case AppLanguageSetting.es:
        return l10n.settingsLanguageEs;
      case AppLanguageSetting.en:
        return l10n.settingsLanguageEn;
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    AppThemeSetting current,
  ) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsTheme),
        content: RadioGroup<AppThemeSetting>(
          groupValue: current,
          onChanged: (val) {
            if (val != null) {
              ref.read(themeSettingProvider.notifier).setTheme(val);
              Navigator.of(ctx).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppThemeSetting.values.map((setting) {
              return RadioListTile<AppThemeSetting>(
                value: setting,
                title: Text(_themeLabel(setting, l10n)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    AppLanguageSetting current,
  ) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsLanguage),
        content: RadioGroup<AppLanguageSetting>(
          groupValue: current,
          onChanged: (val) {
            if (val != null) {
              ref.read(languageSettingProvider.notifier).setLanguage(val);
              Navigator.of(ctx).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLanguageSetting.values.map((setting) {
              return RadioListTile<AppLanguageSetting>(
                value: setting,
                title: Text(_languageLabel(setting, l10n)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showCurrencyDialog(
    BuildContext context,
    WidgetRef ref,
    Currency current,
  ) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsCurrency),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.settingsCurrencyNotice,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            RadioGroup<Currency>(
              groupValue: current,
              onChanged: (val) {
                if (val != null) {
                  ref.read(currencySettingProvider.notifier).setCurrency(val);
                  Navigator.of(ctx).pop();
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: Currency.values.map((cur) {
                  return RadioListTile<Currency>(
                    value: cur,
                    title: Text(cur.code),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBaseIncomeDialog(
    BuildContext context,
    WidgetRef ref,
    int currentUnits,
    Currency currency,
  ) {
    final l10n = AppLocalizations.of(context);
    final ctrl = TextEditingController(
      text: (currentUnits ~/ (currency.decimals == 0 ? 1 : 100)).toString(),
    );

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsBaseIncome),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: '1500000'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final valMajor = int.tryParse(ctrl.text.trim()) ?? 0;
              final units = Money.fromMajor(valMajor, currency).units;
              final setBaseIncome = ref.read(setBaseIncomeUseCaseProvider);
              await setBaseIncome(units);
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showAllocationDialog(
    BuildContext context,
    WidgetRef ref,
    int debts,
    int savings,
    int free,
  ) {
    final l10n = AppLocalizations.of(context);
    final debtsCtrl = TextEditingController(text: debts.toString());
    final savingsCtrl = TextEditingController(text: savings.toString());
    final freeCtrl = TextEditingController(text: free.toString());

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsAllocationRules),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: debtsCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.settingsAllocationDebts,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: savingsCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.settingsAllocationSavings,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: freeCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.settingsAllocationFree,
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
              final d = int.tryParse(debtsCtrl.text.trim()) ?? 0;
              final s = int.tryParse(savingsCtrl.text.trim()) ?? 0;
              final f = int.tryParse(freeCtrl.text.trim()) ?? 0;

              final setRules = ref.read(setAllocationRulesUseCaseProvider);
              final res = await setRules(
                debtsPercent: d,
                savingsPercent: s,
                freePercent: f,
              );

              res.fold(
                onOk: (_) => Navigator.of(ctx).pop(),
                onError: (failure) => ScaffoldMessenger.of(context)
                    .showSnackBar(
                      SnackBar(content: Text(failure.toLocalizedMessage(l10n))),
                    ),
              );
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
