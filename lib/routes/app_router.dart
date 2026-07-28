import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/deposit_page.dart';
import '../pages/developer_settings_page.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/qris_page.dart';
import '../pages/transfer_page.dart';
import '../widgets/app_bottom_navigation.dart';

/// Application route configuration using GoRouter.
final appRouter = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home',
    ),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) =>
          AppShell(location: state.uri.path, child: child),
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          pageBuilder: (_, GoRouterState state) =>
              _fadePage(state, const HomePage()),
        ),
        GoRoute(
          path: '/transfer',
          pageBuilder: (_, GoRouterState state) =>
              _fadePage(state, const TransferPage()),
        ),
        GoRoute(
          path: '/qris',
          pageBuilder: (_, GoRouterState state) =>
              _fadePage(state, const QrisPage()),
        ),
        GoRoute(
          path: '/deposit',
          pageBuilder: (_, GoRouterState state) =>
              _fadePage(state, const DepositPage()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (_, GoRouterState state) =>
              _fadePage(state, const ProfilePage()),
        ),
      ],
    ),
    GoRoute(
      path: '/developer-settings',
      pageBuilder: (_, GoRouterState state) =>
          _fadePage(state, const DeveloperSettingsPage()),
    ),
  ],
);

/// Standard fade transition used on all page routes.
CustomTransitionPage<void> _fadePage(
    GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
        FadeTransition(
      opacity:
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      child: child,
    ),
    transitionDuration: const Duration(milliseconds: 240),
  );
}

/// Shell widget that wraps tab-based pages with bottom navigation.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: location.startsWith('/qris')
          ? null
          : SafeArea(
              top: false,
              child: AppBottomNavigation(location: location),
            ),
    );
  }
}
