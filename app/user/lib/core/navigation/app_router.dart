import 'package:flutter/material.dart';

import '../../screens/complete_profile.dart';
import '../../screens/home.dart';
import '../../screens/login.dart';
import '../../screens/otp.dart';
import '../../screens/splash.dart';

abstract final class AppRouter {
  static const splash = '/';
  static const auth = '/auth';
  static const login = '/login';
  static const home = '/home';
  static const otp = '/otp';
  static const completeProfile = '/complete-profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case otp:
        final verificationId = (settings.arguments as String?) ?? '';
        return MaterialPageRoute(
          builder: (_) => OtpScreen(verificationId: verificationId),
        );
      case completeProfile:
        final phone = (settings.arguments as String?) ?? '';
        return MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(phone: phone),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
