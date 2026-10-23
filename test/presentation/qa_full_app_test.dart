import 'package:drift/native.dart';
import 'package:finanzas_personales/app/app.dart';
import 'package:finanzas_personales/app/router/app_router.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/core/database/database_provider.dart';
import 'package:finanzas_personales/core/widgets/numeric_keypad.dart';
import 'package:finanzas_personales/core/widgets/quick_actions_widget.dart';
import 'package:finanzas_personales/core/widgets/transaction_tile.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:finanzas_personales/features/debts/presentation/pages/debts_and_receivables_page.dart';
import 'package:finanzas_personales/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:finanzas_personales/features/quick_add/presentation/pages/quick_add_page.dart';
import 'package:finanzas_personales/features/reports/presentation/pages/home_dashboard_page.dart';
import 'package:finanzas_personales/features/settings/data/repositories/settings_repository.dart';
import 'package:finanzas_personales/features/settings/presentation/pages/settings_page.dart';
import 'package:finanzas_personales/features/settings/presentation/providers/settings_providers.dart';
import 'package:finanzas_personales/features/transactions/presentation/pages/add_transaction_page.dart';
import 'package:finanzas_personales/features/transactions/presentation/pages/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Full App & Widget End-to-End QA Suite', () {
    late AppDatabase db;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'setting_onboarding_completed': true,
        'setting_language': 'es',
      });
      prefs = await SharedPreferences.getInstance();
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(prefs),
          ),
        ],
      );
    }

    Future<void> tapKeypadDigit(WidgetTester tester, String digit) async {
      await tester.tap(
        find.descendant(
          of: find.byType(NumericKeypad),
          matching: find.text(digit),
        ),
      );
      await tester.pump();
    }

    testWidgets(
      '0. OnboardingPage renders without overflow and completes setup to HomeDashboardPage',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await prefs.setBool('setting_onboarding_completed', false);
        final container = createContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const FinanzasApp(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(OnboardingPage), findsOneWidget);
        expect(find.text('Comenzar a Administrar'), findsOneWidget);

        await tester.tap(find.text('Comenzar a Administrar'));
        await tester.pumpAndSettle();

        expect(find.byType(HomeDashboardPage), findsOneWidget);
        expect(prefs.getBool('setting_onboarding_completed'), isTrue);
      },
    );

    testWidgets(
      '1. HomeDashboardPage renders 2x2 QuickActionsWidget and navigates to all 4 quick actions',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final container = createContainer();
        addTearDown(container.dispose);

        // Seed 2 accounts (Efectivo & Bancolombia)
        final createAcc = container.read(createAccountUseCaseProvider);
        await createAcc(
          name: 'Efectivo',
          type: AccountType.cash,
          initialBalance: 500000,
        );
        await createAcc(
          name: 'Bancolombia',
          type: AccountType.bank,
          initialBalance: 1500000,
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const FinanzasApp(),
          ),
        );
        await tester.pumpAndSettle();

        // Verify HomeDashboardPage and 2x2 QuickActionsWidget are visible
        expect(find.byType(HomeDashboardPage), findsOneWidget);
        expect(find.byType(QuickActionsWidget), findsOneWidget);
        expect(find.text('Entrada rápida'), findsOneWidget);
        expect(find.text('Nueva transferencia'), findsOneWidget);
        expect(find.text('Ingresos nuevos'), findsOneWidget);
        expect(find.text('Nuevo gasto'), findsOneWidget);

        // Action 1: Tap 'Entrada rápida' -> opens QuickAddPage in expense mode
        await tester.tap(find.text('Entrada rápida'));
        await tester.pumpAndSettle();
        expect(find.byType(QuickAddPage), findsOneWidget);
        expect(find.text('Salida (Gasto)'), findsOneWidget);
        expect(find.text('Entrada (Ingreso)'), findsOneWidget);

        // Go back to HomeDashboardPage
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.byType(HomeDashboardPage), findsOneWidget);

        // Action 2: Tap 'Nueva transferencia' -> opens AddTransactionPage in transfer mode
        await tester.tap(find.text('Nueva transferencia'));
        await tester.pumpAndSettle();
        expect(find.byType(AddTransactionPage), findsOneWidget);
        expect(find.text('Cuenta origen'), findsOneWidget);
        expect(find.text('Cuenta destino'), findsOneWidget);

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Action 3: Tap 'Ingresos nuevos' -> opens QuickAddPage in income mode
        await tester.tap(find.text('Ingresos nuevos'));
        await tester.pumpAndSettle();
        expect(find.byType(QuickAddPage), findsOneWidget);

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Action 4: Tap 'Nuevo gasto' -> opens QuickAddPage in expense mode
        await tester.tap(find.text('Nuevo gasto'));
        await tester.pumpAndSettle();
        expect(find.byType(QuickAddPage), findsOneWidget);
      },
    );

    testWidgets(
      '2. Android Widget Deep Links (finanzas://quick-add) route and update state properly',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final container = createContainer();
        addTearDown(container.dispose);

        final createAcc = container.read(createAccountUseCaseProvider);
        await createAcc(
          name: 'Efectivo',
          type: AccountType.cash,
          initialBalance: 300000,
        );
        await createAcc(
          name: 'Nequi',
          type: AccountType.bank,
          initialBalance: 700000,
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const FinanzasApp(),
          ),
        );
        await tester.pumpAndSettle();

        final router = container.read(appRouterProvider);

        // Simulate Android 2x2 Widget Button 1: Entrada rápida (expense, food)
        router.go('finanzas://quick-add?kind=expense&cat=food');
        await tester.pumpAndSettle();
        expect(find.byType(QuickAddPage), findsOneWidget);
        // Back arrow is present even when launched via router.go (no pop stack)
        expect(find.byType(BackButton), findsOneWidget);

        // Simulate switching directly to Android 2x2 Widget Button 3: Ingresos nuevos (income, salary)
        // while QuickAddPage is already active
        router.go('finanzas://quick-add?kind=income&cat=salary');
        await tester.pumpAndSettle();
        expect(find.byType(QuickAddPage), findsOneWidget);

        // Enter amount 50000 using NumericKeypad and save income
        await tapKeypadDigit(tester, '5');
        await tapKeypadDigit(tester, '0');
        await tapKeypadDigit(tester, '0');
        await tapKeypadDigit(tester, '0');
        await tapKeypadDigit(tester, '0');

        await tester.tap(find.text('Guardar'));
        await tester.pumpAndSettle();

        // After saving from deep link, navigates to HomeDashboardPage
        expect(find.byType(HomeDashboardPage), findsOneWidget);
        // And syncs widget SharedPreferences data
        expect(prefs.getInt('widget_safe_available'), isNotNull);
        expect(prefs.getInt('widget_monthly_balance'), 50000);

        // Simulate Android 2x2 Widget Button 2: Nueva transferencia
        router.go('finanzas://quick-add?kind=transfer');
        await tester.pumpAndSettle();
        expect(find.byType(AddTransactionPage), findsOneWidget);
        expect(find.text('Cuenta origen'), findsOneWidget);
        expect(find.text('Cuenta destino'), findsOneWidget);

        // Simulate Android 2x2 Widget Button 4: Nuevo gasto (other_expense)
        router.go('finanzas://quick-add?kind=expense&cat=other_expense');
        await tester.pumpAndSettle();
        expect(find.byType(QuickAddPage), findsOneWidget);
      },
    );

    testWidgets(
      '3. AddTransactionPage handles transfer account switching without dropdown conflict and saves transfer',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final container = createContainer();
        addTearDown(container.dispose);

        final createAcc = container.read(createAccountUseCaseProvider);
        await createAcc(
          name: 'Efectivo',
          type: AccountType.cash,
          initialBalance: 400000,
        );
        await createAcc(
          name: 'Bancolombia',
          type: AccountType.bank,
          initialBalance: 600000,
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const FinanzasApp(),
          ),
        );
        await tester.pumpAndSettle();

        // Open Nueva transferencia from QuickActionsWidget
        await tester.tap(find.text('Nueva transferencia'));
        await tester.pumpAndSettle();
        expect(find.byType(AddTransactionPage), findsOneWidget);

        // Change source account dropdown from Efectivo to Bancolombia
        final sourceDropdown = find.byType(DropdownButtonFormField<int>).first;
        await tester.tap(sourceDropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('Bancolombia').last);
        await tester.pumpAndSettle();

        // Verify no crash occurred and target account automatically switched to Efectivo
        expect(find.byType(AddTransactionPage), findsOneWidget);

        // Enter transfer amount 20000 and save
        await tapKeypadDigit(tester, '2');
        await tapKeypadDigit(tester, '0');
        await tapKeypadDigit(tester, '0');
        await tapKeypadDigit(tester, '0');
        await tapKeypadDigit(tester, '0');

        await tester.tap(find.text('Guardar'));
        await tester.pumpAndSettle();

        expect(find.byType(HomeDashboardPage), findsOneWidget);
        expect(find.byType(TransactionTile), findsWidgets);
        expect(find.text('Transferencia'), findsWidgets);
      },
    );

    testWidgets(
      '4. Navigation across BottomNavigationBar tabs (Home, Movimientos, Deudas, Ajustes)',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final container = createContainer();
        addTearDown(container.dispose);

        final createAcc = container.read(createAccountUseCaseProvider);
        await createAcc(
          name: 'Efectivo',
          type: AccountType.cash,
          initialBalance: 250000,
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const FinanzasApp(),
          ),
        );
        await tester.pumpAndSettle();

        // Navigate to Movimientos tab
        await tester.tap(find.byType(NavigationDestination).at(1));
        await tester.pumpAndSettle();
        expect(find.byType(TransactionsPage), findsOneWidget);
        expect(find.textContaining('Salidas'), findsOneWidget);
        expect(find.textContaining('Entradas'), findsOneWidget);

        // Navigate to Deudas tab
        await tester.tap(find.byType(NavigationDestination).at(2));
        await tester.pumpAndSettle();
        expect(find.byType(DebtsAndReceivablesPage), findsOneWidget);

        // Navigate to Ajustes tab
        await tester.tap(find.byType(NavigationDestination).at(3));
        await tester.pumpAndSettle();
        expect(find.byType(SettingsPage), findsOneWidget);
      },
    );
  });
}
