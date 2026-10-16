import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/finance_colors.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/money/money.dart';
import '../../../../core/widgets/charts.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../providers/reports_providers.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
  }

  void _previousMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear -= 1;
      } else {
        _selectedMonth -= 1;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear += 1;
      } else {
        _selectedMonth += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencySettingProvider);
    final locale = Localizations.localeOf(context).languageCode;

    final monthDate = DateTime(_selectedYear, _selectedMonth);
    final monthLabel = DateFormat.yMMMM(locale).format(monthDate);

    final summaryAsync = ref.watch(
      monthlySummaryProvider((year: _selectedYear, month: _selectedMonth)),
    );
    final breakdownAsync = ref.watch(
      categoryBreakdownProvider((year: _selectedYear, month: _selectedMonth)),
    );
    final totalsAsync = ref.watch(monthlyTotalsProvider);
    final motoAsync = ref.watch(
      motoReportProvider((year: _selectedYear, month: _selectedMonth)),
    );
    final coupleAsync = ref.watch(
      coupleReportProvider((year: _selectedYear, month: _selectedMonth)),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Month selector
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: _previousMonth,
                  ),
                  Text(
                    monthLabel.toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Summary Cards
          summaryAsync.when(
            data: (summary) {
              final incMoney = Money(
                units: summary.totalIncome,
                currency: currency,
              );
              final expMoney = Money(
                units: summary.totalExpense,
                currency: currency,
              );
              final netMoney = Money(
                units: summary.balance,
                currency: currency,
              );

              return Row(
                children: [
                  Expanded(
                    child: _statCard(
                      context,
                      label: l10n.reportsTotalIncome,
                      money: incMoney,
                      color: colors.income,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _statCard(
                      context,
                      label: l10n.reportsTotalExpense,
                      money: expMoney,
                      color: colors.expense,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _statCard(
                      context,
                      label: l10n.reportsNetBalance,
                      money: netMoney,
                      color: netMoney.units >= 0
                          ? colors.income
                          : colors.expense,
                    ),
                  ),
                ],
              );
            },
            loading: () => const SkeletonCard(height: 80),
            error: (e, _) => ErrorStateWidget(customMessage: e.toString()),
          ),
          const SizedBox(height: 20),

          // Donut Chart Breakdown
          Text(
            l10n.reportsCategoryBreakdown,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          breakdownAsync.when(
            data: (breakdown) {
              if (breakdown.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        l10n.reportsEmptyData,
                        style: TextStyle(color: colors.onSurfaceMuted),
                      ),
                    ),
                  ),
                );
              }

              final totalExpense = breakdown.fold<int>(
                0,
                (sum, i) => sum + i.totalAmount,
              );
              final totalExpMoney = Money(
                units: totalExpense,
                currency: currency,
              );

              final segments = breakdown.map((item) {
                final label = l10n.translateCategoryKey(item.categoryKeyOrName);
                return ChartSegment(
                  label: label,
                  amount: item.totalAmount,
                  percentage: item.percentage,
                  color: Color(item.color),
                );
              }).toList();

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DonutChartWidget(
                    segments: segments,
                    totalAmount: totalExpMoney,
                    totalLabel: l10n.reportsTotalExpense,
                  ),
                ),
              );
            },
            loading: () => const SkeletonCard(height: 240),
            error: (e, _) => ErrorStateWidget(customMessage: e.toString()),
          ),
          const SizedBox(height: 20),

          // Monthly Evolution Bar Chart
          Text(
            l10n.reportsMonthlyEvolution,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          totalsAsync.when(
            data: (totals) {
              final chartItems = totals.map((t) {
                final d = DateTime(t.year, t.month);
                final shortMonth = DateFormat.MMM(locale).format(d);
                return BarChartItem(
                  label: shortMonth,
                  income: t.totalIncome,
                  expense: t.totalExpense,
                );
              }).toList();

              return MonthlyBarChartWidget(
                items: chartItems,
                currency: currency,
              );
            },
            loading: () => const SkeletonCard(height: 180),
            error: (e, _) => ErrorStateWidget(customMessage: e.toString()),
          ),
          const SizedBox(height: 20),

          // Special Grouped Reports: Moto & Outings/Partner
          Text(
            l10n.reportsSpecialGroupings,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Moto Report Card (RN-22)
          motoAsync.when(
            data: (moto) {
              final motoMoney = Money(
                units: moto.totalAmount,
                currency: currency,
              );
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.two_wheeler_rounded,
                                color: colors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.reportMotoTitle,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Text(
                            motoMoney.format(),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.reportMotoDescription,
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: colors.onSurfaceMuted),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: moto.categoryKeys.map((key) {
                          return Chip(
                            label: Text(
                              l10n.translateCategoryKey(key),
                              style: const TextStyle(fontSize: 11),
                            ),
                            padding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SkeletonCard(height: 80),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),

          // Outings & Partner Report Card (RN-23)
          coupleAsync.when(
            data: (couple) {
              final coupleMoney = Money(
                units: couple.totalAmount,
                currency: currency,
              );
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.favorite_rounded,
                                color: colors.savings,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.reportOutingsTitle,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Text(
                            coupleMoney.format(),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.savings,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.reportOutingsDescription,
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: colors.onSurfaceMuted),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: couple.categoryKeys.map((key) {
                          return Chip(
                            label: Text(
                              l10n.translateCategoryKey(key),
                              style: const TextStyle(fontSize: 11),
                            ),
                            padding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SkeletonCard(height: 80),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String label,
    required Money money,
    required Color color,
  }) {
    final colors = context.colors;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: colors.onSurfaceMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              money.format(),
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
