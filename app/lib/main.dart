import 'dart:async';

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

  StreamSubscription? _tcStream;

  String? _codeVerifier;
  String? _oauthState;

  // ================= INIT =================

  @override
  void initState() {
    super.initState();

    _initTruecaller();
    _listenTruecaller();
  }

  void _initTruecaller() {
    TcSdk.initializeSDK(
      sdkOption: TcSdkOptions.OPTION_VERIFY_ALL_USERS,
    );
  }

  // ================= TRUECALLER LISTENER =================

  void _listenTruecaller() {

    _tcStream = TcSdk.streamCallbackData.listen((res) async {

      switch (res.result) {

        case TcSdkCallbackResult.success:

          final authCode = res.tcOAuthData!.authorizationCode;

          debugPrint("AuthCode: $authCode");

          // 👉 Normally: Send to backend → get token
          // For MVP: Trust login

          _goHome();
          break;

        case TcSdkCallbackResult.verification:

          _show("Manual verification required");
          break;

        case TcSdkCallbackResult.failure:

          _show(res.error?.message ?? "Truecaller Failed");
          break;

        default:
          break;
      }
    });
  }

  // ================= START TRUECALLER =================

  Future<void> startTruecallerLogin() async {

    final usable = await TcSdk.isOAuthFlowUsable;

    if (!usable) {
      _show("Truecaller not available");
      return;
    }

    _oauthState = DateTime.now().millisecondsSinceEpoch.toString();

    TcSdk.setOAuthState(_oauthState!);

    TcSdk.setOAuthScopes(['profile', 'phone', 'openid']);

    _codeVerifier = await TcSdk.generateRandomCodeVerifier;

    final challenge =
        await TcSdk.generateCodeChallenge(_codeVerifier!);

    if (challenge == null) {
      _show("Device not supported");
      return;
    }

    TcSdk.setCodeChallenge(challenge);

    TcSdk.getAuthorizationCode;
  }

  // ================= OTP =================

  Future<void> sendOtp() async {

    final phone = phoneController.text.trim();

    if (phone.length != 10) {
      _show("Invalid number");
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
        _show(e.message ?? "OTP failed");
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

  // ================= HELPERS =================

  void _goHome() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _show(String s) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s)));
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    phoneController.dispose();
    _tcStream?.cancel();
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
              "Continue with Truecaller or OTP",
              style: TextStyle(color: Colors.white60),
            ),

            const SizedBox(height: 30),

            // Phone
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

            // TRUECALLER
            SizedBox(
              width: double.infinity,
              height: 52,

              child: OutlinedButton.icon(
                icon: const Icon(Icons.verified_user),
                label: const Text("Login with Truecaller"),
                onPressed: startTruecallerLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}