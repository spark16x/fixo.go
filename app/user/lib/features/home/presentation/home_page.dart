import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIXO.GO User'),
        actions: [
          IconButton(onPressed: () => context.go('/profile'), icon: const Icon(Icons.person)),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: FilledButton.icon(
          onPressed: () => context.go('/request'),
          icon: const Icon(Icons.car_repair),
          label: const Text('Request Roadside Assistance'),
        ),
      ),
    );
  }
}
