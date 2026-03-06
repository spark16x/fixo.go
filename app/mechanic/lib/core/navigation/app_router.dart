import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_gate.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/otp_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/requests/presentation/incoming_requests_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', pageBuilder: (context, state) => _animatedPage(state, const AuthGate())),
      GoRoute(path: '/login', pageBuilder: (context, state) => _animatedPage(state, const LoginPage())),

      GoRoute(path: '/home', pageBuilder: (context, state) => _animatedPage(state, const HomePage())),
      GoRoute(path: '/incoming', pageBuilder: (context, state) => _animatedPage(state, const IncomingRequestsPage())),
      GoRoute(path: '/profile', pageBuilder: (context, state) => _animatedPage(state, const ProfilePage())),
    ],
  );
});

CustomTransitionPage<void> _animatedPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, pageChild) {
      final slideTween = Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      final fadeTween = Tween<double>(begin: 0, end: 1)
          .chain(CurveTween(curve: Curves.easeOut));
      return SlideTransition(
        position: animation.drive(slideTween),
        child: FadeTransition(opacity: animation.drive(fadeTween), child: pageChild),
      );
    },
  );
}
