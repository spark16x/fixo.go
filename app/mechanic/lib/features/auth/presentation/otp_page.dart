import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_providers.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key, required this.verificationId});
  final String verificationId;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _otpController = TextEditingController();

  Future<void> _verify() async {
    await ref.read(otpServiceProvider).verify(widget.verificationId, _otpController.text.trim());
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _otpController, decoration: const InputDecoration(labelText: 'OTP')),
          const SizedBox(height: 16),
          FilledButton(onPressed: _verify, child: const Text('Verify')),
        ]),
      ),
    );
  }
}
