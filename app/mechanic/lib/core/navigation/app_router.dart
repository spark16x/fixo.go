import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../screens/complete_profile.dart';
import '../../screens/home.dart';
import '../../screens/login.dart';
import '../../screens/otp.dart';
import '../../screens/splash.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthWrapper(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final verificationId =
              state.uri.queryParameters['verificationId'] ?? '';
          return OtpScreen(verificationId: verificationId);
        },
      ),
      GoRoute(
        path: '/complete-profile',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return CompleteProfileScreen(phone: phone);
        },
      ),
    ],
  );
});
