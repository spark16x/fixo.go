import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController(text: '+91');

  Future<void> _send() async {
    final id = await ref.read(otpServiceProvider).sendOtp(_phoneController.text.trim());
    if (mounted) context.go('/otp?vid=$id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mechanic Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone')),
          const SizedBox(height: 16),
          FilledButton(onPressed: _send, child: const Text('Send OTP')),
        ]),
      ),
    );
  }
}
