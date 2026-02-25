import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

import 'otp.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final phoneController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();

    TruecallerSdk.initializeSDK(
      sdkOptions: TruecallerSdkScope.SDK_OPTION_WITH_OTP,
      consentMode: TruecallerSdkScope.CONSENT_MODE_POPUP,
      loginTextPrefix: TruecallerSdkScope.LOGIN_TEXT_PREFIX_TO_GET_STARTED,
      loginTextSuffix: TruecallerSdkScope.LOGIN_TEXT_SUFFIX_PLEASE_LOGIN,
    );
  }

  // ================= OTP =================

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();

    if (phone.length != 10) {
      _msg("Invalid number");
      return;
    }

    setState(() => loading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91$phone",

      verificationCompleted: (cred) async {
        await FirebaseAuth.instance.signInWithCredential(cred);
        _goHome();
      },

      verificationFailed: (e) {
        setState(() => loading = false);
        _msg(e.message ?? "OTP Failed");
      },

      codeSent: (id, _) {
        setState(() => loading = false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(verificationId: id),
          ),
        );
      },

      codeAutoRetrievalTimeout: (_) {
        setState(() => loading = false);
      },
    );
  }

  // ================= TRUECALLER =================

  Future<void> loginTruecaller() async {

    final res = await TruecallerSdk.getProfile();

    if (res['success'] == true) {
      _goHome();
    } else {
      _msg("Truecaller cancelled");
    }
  }

  // ================= HELPERS =================

  void _goHome() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _msg(String s) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s)));
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Login",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Continue with phone or Truecaller",
              style: TextStyle(color: Colors.white60),
            ),

            const SizedBox(height: 30),

            // Phone field
            TextField(
              controller: phoneController,
              maxLength: 10,
              keyboardType: TextInputType.phone,

              decoration: InputDecoration(
                prefixText: "+91 ",
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // OTP
            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: loading ? null : sendOtp,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Continue with OTP"),
              ),
            ),

            const SizedBox(height: 20),

            const Center(child: Text("OR")),

            const SizedBox(height: 20),

            // Truecaller
            SizedBox(
              width: double.infinity,
              height: 52,

              child: OutlinedButton(
                onPressed: loginTruecaller,
                child: const Text("Login with Truecaller"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}