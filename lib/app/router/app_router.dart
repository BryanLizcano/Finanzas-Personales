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

CustomTransitionPage<T> _buildSmoothPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 230),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final offsetTween = Tween<Offset>(
        begin: const Offset(0.0, 0.035),
        end: Offset.zero,
      );
      final scaleTween = Tween<double>(begin: 0.985, end: 1.0);

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: offsetTween.animate(curved),
          child: ScaleTransition(
            scale: scaleTween.animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier<bool>(
    ref.read(onboardingCompletedProvider),
  );
  ref.onDispose(refreshNotifier.dispose);
  ref.listen<bool>(onboardingCompletedProvider, (_, next) {
    refreshNotifier.value = next;
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: ref.read(onboardingCompletedProvider)
        ? '/'
        : '/onboarding',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      if (state.uri.scheme == 'finanzas' &&
          (state.uri.host == 'quick-add' || state.uri.path == '/quick-add')) {
        final query = state.uri.query;
        return query.isNotEmpty ? '/quick-add?$query' : '/quick-add';
      }

      final isOnboardingCompleted = ref.read(onboardingCompletedProvider);
      final goingToOnboarding = state.matchedLocation == '/onboarding';
      final goingToQuickAdd = state.matchedLocation == '/quick-add';
      final goingToAddTx = state.matchedLocation == '/add-transaction';

      if (!isOnboardingCompleted &&
          !goingToOnboarding &&
          !goingToQuickAdd &&
          !goingToAddTx) {
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
        pageBuilder: (context, state) => _buildSmoothPage(
          key: state.pageKey,
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: '/quick-add',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final uriString = state.uri.toString();
          final parseUseCase = ref.read(parseQuickAddLinkUseCaseProvider);
          final res = parseUseCase(uriString);
          final payload =
              res.valueOrNull ??
              const QuickAddPayload(kind: TransactionKind.expense);
          final pageChild = payload.kind == TransactionKind.transfer
              ? const AddTransactionPage(initialKind: TransactionKind.transfer)
              : QuickAddPage(payload: payload);
          return _buildSmoothPage(
            key: ValueKey('quick_add_$uriString'),
            child: pageChild,
          );
        },
      ),
      GoRoute(
        path: '/add-transaction',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final uriString = state.uri.toString();
          final kindParam = state.uri.queryParameters['kind']?.toLowerCase();
          final catParam = state.uri.queryParameters['cat'];
          final amountParam = state.uri.queryParameters['amount'];
          final amountUnits = amountParam != null
              ? int.tryParse(amountParam)
              : null;
          final initialKind = switch (kindParam) {
            'income' => TransactionKind.income,
            'transfer' => TransactionKind.transfer,
            _ => TransactionKind.expense,
          };
          return _buildSmoothPage(
            key: ValueKey('add_tx_$uriString'),
            child: AddTransactionPage(
              initialKind: initialKind,
              initialCategoryKey: catParam,
              initialAmountUnits: amountUnits,
            ),
          );
        },
      ),
      GoRoute(
        path: '/reports',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildSmoothPage(
          key: state.pageKey,
          child: const ReportsPage(),
        ),
      ),
      GoRoute(
        path: '/savings',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildSmoothPage(
          key: state.pageKey,
          child: const SavingsPage(),
        ),
      ),
      GoRoute(
        path: '/accounts',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildSmoothPage(
          key: state.pageKey,
          child: const AccountsPage(),
        ),
      ),
      GoRoute(
        path: '/categories',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildSmoothPage(
          key: state.pageKey,
          child: const CategoriesPage(),
        ),
      ),
      GoRoute(
        path: '/backup',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildSmoothPage(
          key: state.pageKey,
          child: const BackupPage(),
        ),
      ),
      GoRoute(
        path: '/updates',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildSmoothPage(
          key: state.pageKey,
          child: const UpdatesPage(),
        ),
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
                pageBuilder: (context, state) => _buildSmoothPage(
                  key: state.pageKey,
                  child: const HomeDashboardPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _sectionTxKey,
            routes: [
              GoRoute(
                path: '/transactions',
                pageBuilder: (context, state) => _buildSmoothPage(
                  key: state.pageKey,
                  child: const TransactionsPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _sectionDebtsKey,
            routes: [
              GoRoute(
                path: '/debts-receivables',
                pageBuilder: (context, state) => _buildSmoothPage(
                  key: state.pageKey,
                  child: const DebtsAndReceivablesPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _sectionSettingsKey,
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => _buildSmoothPage(
                  key: state.pageKey,
                  child: const SettingsPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
