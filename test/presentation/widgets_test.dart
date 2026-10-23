import 'package:finanzas_personales/app/theme/app_theme.dart';
import 'package:finanzas_personales/core/money/currency.dart';
import 'package:finanzas_personales/core/money/money.dart';
import 'package:finanzas_personales/core/widgets/amount_input_field.dart';
import 'package:finanzas_personales/core/widgets/animated_count.dart';
import 'package:finanzas_personales/core/widgets/app_button.dart';
import 'package:finanzas_personales/core/widgets/app_progress_bar.dart';
import 'package:finanzas_personales/core/widgets/balance_card.dart';
import 'package:finanzas_personales/core/widgets/category_chip.dart';
import 'package:finanzas_personales/core/widgets/charts.dart';
import 'package:finanzas_personales/core/widgets/empty_state_widget.dart';
import 'package:finanzas_personales/core/widgets/error_state_widget.dart';
import 'package:finanzas_personales/core/widgets/numeric_keypad.dart';
import 'package:finanzas_personales/core/widgets/quick_actions_widget.dart';
import 'package:finanzas_personales/core/widgets/skeleton_loading.dart';
import 'package:finanzas_personales/core/widgets/transaction_tile.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:finanzas_personales/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('es'),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('Core Presentation Widgets', () {
    testWidgets('AnimatedMoneyText renders formatted money', (tester) async {
      const money = Money(units: 1250000, currency: Currency.cop);
      await tester.pumpWidget(
        _buildTestApp(const AnimatedMoneyText(money: money)),
      );
      await tester.pumpAndSettle();

      expect(find.text(r'$ 1.250.000'), findsOneWidget);
    });

    testWidgets('BalanceCard displays title, amount and subtitle', (
      tester,
    ) async {
      const money = Money(units: 450000, currency: Currency.cop);
      await tester.pumpWidget(
        _buildTestApp(
          const BalanceCard(
            title: 'Disponible Real',
            money: money,
            subtitle: 'Calculado según regla segura',
            icon: Icons.shield_outlined,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Disponible Real'), findsOneWidget);
      expect(find.text(r'$ 450.000'), findsOneWidget);
      expect(find.text('Calculado según regla segura'), findsOneWidget);
    });

    testWidgets('CategoryChip displays title and handles selection', (
      tester,
    ) async {
      bool selected = false;
      await tester.pumpWidget(
        _buildTestApp(
          StatefulBuilder(
            builder: (context, setState) {
              return CategoryChip(
                icon: 'fastfood',
                title: 'Restaurantes',
                color: Colors.orange,
                isSelected: selected,
                onTap: () => setState(() => selected = !selected),
              );
            },
          ),
        ),
      );

      expect(find.text('Restaurantes'), findsOneWidget);
      await tester.tap(find.text('Restaurantes'));
      await tester.pumpAndSettle();
      expect(selected, isTrue);
    });

    testWidgets('NumericKeypad inputs numbers, backspace, and clear', (
      tester,
    ) async {
      String typed = '';

      await tester.pumpWidget(
        _buildTestApp(
          NumericKeypad(
            currency: Currency.cop,
            onDigit: (digit) => typed += digit,
            onBackspace: () {
              if (typed.isNotEmpty) {
                typed = typed.substring(0, typed.length - 1);
              }
            },
            onClear: () => typed = '',
          ),
        ),
      );

      await tester.tap(find.text('1'));
      await tester.tap(find.text('5'));
      await tester.tap(find.text('0'));
      expect(typed, '150');

      await tester.tap(find.byIcon(Icons.backspace_outlined));
      expect(typed, '15');

      await tester.longPress(find.byIcon(Icons.backspace_outlined));
      expect(typed, '');
    });

    testWidgets('AmountInputField displays formatted value with currency', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          const AmountInputField(rawInput: '350000', currency: Currency.cop),
        ),
      );

      expect(find.text(r'$ '), findsOneWidget);
      expect(find.text('350000'), findsOneWidget);
    });

    testWidgets('AppButton renders primary and loading state', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        _buildTestApp(
          Column(
            children: [
              AppButton(label: 'Guardar', onPressed: () => tapped = true),
              const AppButton(
                label: 'Cargando',
                isLoading: true,
                onPressed: null,
              ),
            ],
          ),
        ),
      );

      expect(find.text('Guardar'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.text('Guardar'));
      expect(tapped, isTrue);
    });

    testWidgets('AppProgressBar and AppCircularProgress display progress', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          const Column(
            children: [
              AppProgressBar(progress: 0.75),
              AppCircularProgress(progress: 0.5),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppProgressBar), findsOneWidget);
      expect(find.byType(AppCircularProgress), findsOneWidget);
    });

    testWidgets('EmptyStateWidget renders illustration and action', (
      tester,
    ) async {
      bool actionPressed = false;
      await tester.pumpWidget(
        _buildTestApp(
          EmptyStateWidget(
            title: 'Sin movimientos',
            subtitle: 'Agrega tu primera transacción.',
            actionLabel: 'Crear gasto',
            onAction: () => actionPressed = true,
          ),
        ),
      );

      expect(find.text('Sin movimientos'), findsOneWidget);
      expect(find.text('Agrega tu primera transacción.'), findsOneWidget);
      expect(find.text('Crear gasto'), findsOneWidget);

      await tester.tap(find.text('Crear gasto'));
      expect(actionPressed, isTrue);
    });

    testWidgets('ErrorStateWidget renders error details and retry button', (
      tester,
    ) async {
      bool retried = false;
      await tester.pumpWidget(
        _buildTestApp(
          ErrorStateWidget(
            customMessage: 'Error al conectar con la base de datos.',
            onRetry: () => retried = true,
          ),
        ),
      );

      expect(
        find.text('Error al conectar con la base de datos.'),
        findsOneWidget,
      );
      expect(find.text('Reintentar'), findsOneWidget);

      await tester.tap(find.text('Reintentar'));
      expect(retried, isTrue);
    });

    testWidgets('SkeletonBox and SkeletonCard render shimmer placeholders', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          const Column(
            children: [
              SkeletonBox(width: 100, height: 20),
              SkeletonCard(height: 80),
            ],
          ),
        ),
      );

      expect(find.byType(SkeletonBox), findsWidgets);
      expect(find.byType(SkeletonCard), findsOneWidget);
    });

    testWidgets('DonutChartWidget and MonthlyBarChartWidget paint correctly', (
      tester,
    ) async {
      const segments = [
        ChartSegment(
          label: 'Alimentación',
          amount: 200000,
          percentage: 60.0,
          color: Color(0xFF0D9488),
        ),
        ChartSegment(
          label: 'Transporte',
          amount: 133333,
          percentage: 40.0,
          color: Color(0xFFF59E0B),
        ),
      ];

      const barItems = [
        BarChartItem(label: 'Ene', income: 1000000, expense: 700000),
        BarChartItem(label: 'Feb', income: 1200000, expense: 800000),
      ];

      await tester.pumpWidget(
        _buildTestApp(
          const SingleChildScrollView(
            child: Column(
              children: [
                DonutChartWidget(
                  segments: segments,
                  totalAmount: Money(units: 333333, currency: Currency.cop),
                  totalLabel: 'Total Gastos',
                ),
                MonthlyBarChartWidget(items: barItems, currency: Currency.cop),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DonutChartWidget), findsOneWidget);
      expect(find.byType(MonthlyBarChartWidget), findsOneWidget);
      expect(find.text('Alimentación'), findsOneWidget);
      expect(find.text('Transporte'), findsOneWidget);
    });

    testWidgets('QuickActionsWidget renders 4 minimalist cards and handles taps', (
      tester,
    ) async {
      String? lastAction;
      await tester.pumpWidget(
        _buildTestApp(
          QuickActionsWidget(
            onQuickEntry: () => lastAction = 'quick',
            onNewTransfer: () => lastAction = 'transfer',
            onNewIncome: () => lastAction = 'income',
            onNewExpense: () => lastAction = 'expense',
          ),
        ),
      );

      expect(find.text('Entrada rápida'), findsOneWidget);
      expect(find.text('Nueva transferencia'), findsOneWidget);
      expect(find.text('Ingresos nuevos'), findsOneWidget);
      expect(find.text('Nuevo gasto'), findsOneWidget);

      await tester.tap(find.text('Entrada rápida'));
      expect(lastAction, 'quick');

      await tester.tap(find.text('Nueva transferencia'));
      expect(lastAction, 'transfer');

      await tester.tap(find.text('Ingresos nuevos'));
      expect(lastAction, 'income');

      await tester.tap(find.text('Nuevo gasto'));
      expect(lastAction, 'expense');
    });

    testWidgets('TransactionTile highlights Entrada/Salida and Efectivo/Cuenta', (
      tester,
    ) async {
      final now = DateTime(2026, 10, 22);
      final expenseTx = TransactionEntity(
        id: 1,
        kind: TransactionKind.expense,
        amount: 25000,
        accountId: 1,
        categoryId: 1,
        occurredAt: now,
        createdAt: now,
        updatedAt: now,
      );
      final incomeTx = TransactionEntity(
        id: 2,
        kind: TransactionKind.income,
        amount: 180000,
        accountId: 2,
        categoryId: 2,
        occurredAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(
        _buildTestApp(
          Column(
            children: [
              TransactionTile(
                transaction: expenseTx,
                currency: Currency.cop,
                categoryTitle: 'Restaurantes',
                accountName: 'Billetera',
                accountType: AccountType.cash,
              ),
              TransactionTile(
                transaction: incomeTx,
                currency: Currency.cop,
                categoryTitle: 'Sueldo',
                accountName: 'Bancolombia',
                accountType: AccountType.bank,
              ),
            ],
          ),
        ),
      );

      expect(find.text('Salida'), findsOneWidget);
      expect(find.text('Entrada'), findsOneWidget);
      expect(find.textContaining('Efectivo'), findsOneWidget);
      expect(find.textContaining('Cuenta • Bancolombia'), findsOneWidget);
    });
  });
}
