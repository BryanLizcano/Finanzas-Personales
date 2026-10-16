import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts/presentation/pages/accounts_page.dart';
import '../../features/backup/presentation/pages/backup_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/debts/presentation/pages/debts_and_receivables_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/quick_add/domain/entities/quick_add_payload.dart';
import '../../features/quick_add/presentation/pages/quick_add_page.dart';
import '../../features/quick_add/presentation/providers/quick_add_providers.dart';
import '../../features/reports/presentation/pages/home_dashboard_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/savings/presentation/pages/savings_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/providers/settings_providers.dart';
import '../../features/transactions/domain/entities/transaction.dart';
import '../../features/transactions/presentation/pages/add_transaction_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/updates/presentation/pages/updates_page.dart';
import 'app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _sectionHomeKey = GlobalKey<NavigatorState>(debugLabel: 'sectionHome');
final _sectionTxKey = GlobalKey<NavigatorState>(debugLabel: 'sectionTx');
final _sectionDebtsKey = GlobalKey<NavigatorState>(debugLabel: 'sectionDebts');
final _sectionSettingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'sectionSettings',
);

final appRouterProvider = Provider<GoRouter>((ref) {
  final isOnboardingCompleted = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: isOnboardingCompleted ? '/' : '/onboarding',
    redirect: (context, state) {
      final goingToOnboarding = state.matchedLocation == '/onboarding';
      final goingToQuickAdd = state.matchedLocation == '/quick-add';

      if (!isOnboardingCompleted && !goingToOnboarding && !goingToQuickAdd) {
        return '/onboarding';
      }
      if (isOnboardingCompleted && goingToOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/quick-add',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final uriString = state.uri.toString();
          final parseUseCase = ref.read(parseQuickAddLinkUseCaseProvider);
          final res = parseUseCase(uriString);
          final payload =
              res.valueOrNull ??
              const QuickAddPayload(kind: TransactionKind.expense);
          return QuickAddPage(payload: payload);
        },
      ),
      GoRoute(
        path: '/add-transaction',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const AddTransactionPage();
        },
      ),
      GoRoute(
        path: '/reports',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        path: '/savings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SavingsPage(),
      ),
      GoRoute(
        path: '/accounts',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AccountsPage(),
      ),
      GoRoute(
        path: '/categories',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CategoriesPage(),
      ),
      GoRoute(
        path: '/backup',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BackupPage(),
      ),
      GoRoute(
        path: '/updates',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const UpdatesPage(),
      ),

      // 4 Main Bottom Navigation Tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _sectionHomeKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeDashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _sectionTxKey,
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _sectionDebtsKey,
            routes: [
              GoRoute(
                path: '/debts-receivables',
                builder: (context, state) => const DebtsAndReceivablesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _sectionSettingsKey,
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
