import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/dashboard/presentation/pages/main_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/transactions/presentation/pages/add_transaction_page.dart';
import '../../features/transactions/presentation/pages/transaction_detail_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/budget_settings_page.dart';
import '../../features/settings/presentation/pages/notification_settings_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.when(
        data: (user) => user != null,
        loading: () => false,
        error: (_, __) => false,
      );
      
      final isOnSplash = state.location == '/splash';
      final isOnAuth = state.location.startsWith('/auth');
      final isOnOnboarding = state.location == '/onboarding';
      
      // If not logged in and not on auth/splash/onboarding pages, redirect to login
      if (!isLoggedIn && !isOnAuth && !isOnSplash && !isOnOnboarding) {
        return '/auth/login';
      }
      
      // If logged in and on auth pages, redirect to home
      if (isLoggedIn && isOnAuth) {
        return '/';
      }
      
      return null;
    },
    routes: [
      // Splash Route
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      
      // Onboarding Route
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Auth Routes
      GoRoute(
        path: '/auth',
        redirect: (context, state) => '/auth/login',
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      
      // Main App Routes
      ShellRoute(
        builder: (context, state, child) => MainPage(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/transactions',
            name: 'transactions',
            builder: (context, state) => const TransactionsPage(),
            routes: [
              GoRoute(
                path: '/add',
                name: 'add-transaction',
                builder: (context, state) => const AddTransactionPage(),
              ),
              GoRoute(
                path: '/:id',
                name: 'transaction-detail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return TransactionDetailPage(transactionId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (context, state) => const ReportsPage(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
              ),
              GoRoute(
                path: '/budget',
                name: 'budget-settings',
                builder: (context, state) => const BudgetSettingsPage(),
              ),
              GoRoute(
                path: '/notifications',
                name: 'notification-settings',
                builder: (context, state) => const NotificationSettingsPage(),
              ),
            ],
          ),
        ],
      ),
      
      // Standalone Add Transaction Route (for FAB)
      GoRoute(
        path: '/add-transaction',
        name: 'add-transaction-standalone',
        builder: (context, state) => const AddTransactionPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Custom page transitions
class SlideTransitionPage extends CustomTransitionPage<void> {
  const SlideTransitionPage({
    required super.child,
    required super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionsBuilder: _slideTransition,
          transitionDuration: const Duration(milliseconds: 300),
        );

  static Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
      ),
      child: child,
    );
  }
}

class FadeTransitionPage extends CustomTransitionPage<void> {
  const FadeTransitionPage({
    required super.child,
    required super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionsBuilder: _fadeTransition,
          transitionDuration: const Duration(milliseconds: 200),
        );

  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}