import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_providers.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    return auth.when(
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/login'));
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final profile = ref.watch(profileExistsProvider);
        return profile.when(
          data: (exists) {
            WidgetsBinding.instance.addPostFrameCallback((_) => context.go(exists ? '/home' : '/profile'));
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          },
          error: (_, __) => const Scaffold(body: Center(child: Text('Error'))),
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
      error: (_, __) => const Scaffold(body: Center(child: Text('Error'))),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
