import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_providers.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key, required this.verificationId, required this.phoneNumber});
  final String verificationId;
  final String phoneNumber;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _otpController = TextEditingController();
  bool _loading = false;

  Future<void> _verify() async {
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).verifyOtp(
            verificationId: widget.verificationId,
            smsCode: _otpController.text.trim(),
          );
      if (mounted) context.go('/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid OTP: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify ${widget.phoneNumber}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _otpController, decoration: const InputDecoration(labelText: 'OTP')),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loading ? null : _verify, child: Text(_loading ? 'Verifying...' : 'Verify')),
          ],
        ),
      ),
    );
  }
}
