import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  bool loading = false;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ================= VERIFY OTP =================

  Future<void> verifyOtp() async {

    String code = _controllers.map((c) => c.text).join();

    if (code.length != 6) {
      _show("Enter complete OTP");
      return;
    }

    setState(() => loading = true);

    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: code,
      );

      await FirebaseAuth.instance.signInWithCredential(cred);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );

    } catch (e) {
      _show("Invalid OTP");
    }

    setState(() => loading = false);
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: colors.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            Text(
              'Verify OTP',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Enter the 6-digit code sent to your phone',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(.6),
              ),
            ),

            const SizedBox(height: 40),

            // OTP Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  List.generate(6, (index) => _otpBox(index)),
            ),

            const SizedBox(height: 40),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: loading ? null : verifyOtp,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Verify & Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color:
                        colors.onSurface.withOpacity(.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= OTP BOX =================

  Widget _otpBox(int index) {

    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: _controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,

        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colors.onSurface,
        ),

        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: colors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),

        onChanged: (value) {

          // forward focus
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }

          // backward focus
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}