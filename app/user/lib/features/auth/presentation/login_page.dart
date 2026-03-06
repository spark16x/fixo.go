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
  final _controller = TextEditingController(text: '+91');
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    setState(() => _loading = true);
    try {
      final id = await ref.read(authRepositoryProvider).sendOtp(_controller.text.trim());
      if (mounted) context.go('/otp?vid=$id&phone=${Uri.encodeComponent(_controller.text.trim())}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Phone Number')),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loading ? null : _sendOtp, child: Text(_loading ? 'Sending...' : 'Send OTP')),
          ],
        ),
      ),
    );
  }
}
