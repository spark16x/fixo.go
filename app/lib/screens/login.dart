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

  final TextEditingController phoneController =
      TextEditingController();

  bool loading = false;
  bool truecallerAvailable = false;

  StreamSubscription? _tcStream;

  String? _codeVerifier;
  String? _oauthState;

  // ================= INIT =================

  @override
  void initState() {
    super.initState();
    _initializeTruecaller();
  }

  Future<void> _initializeTruecaller() async {

    TcSdk.initializeSDK(
      sdkOption: TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS,
    );

    _listenTruecaller();

    /// Check availability
    truecallerAvailable =
        await TcSdk.isOAuthFlowUsable;

    if (mounted) setState(() {});
  }

  // ================= TRUECALLER LISTENER =================

  void _listenTruecaller() {

    _tcStream =
        TcSdk.streamCallbackData.listen((callback) async {

      switch (callback.result) {

        /// ===== SUCCESS =====
        case TcSdkCallbackResult.success:

          final data = callback.tcOAuthData;

          if (data == null) {
            _stopLoading();
            _show("Invalid Truecaller response");
            return;
          }

          /// OAuth state validation
          if (data.state != _oauthState) {
            _stopLoading();
            _show("Security validation failed");
            return;
          }

          final authCode = data.authorizationCode;

          debugPrint("AuthCode: $authCode");

          await _exchangeTokenWithBackend(
            authCode,
            _codeVerifier!,
          );

          break;

        /// ===== FAILURE =====
        case TcSdkCallbackResult.failure:
          _stopLoading();
          _show(callback.error?.message ??
              "Truecaller login failed");
          break;

        /// ===== EXCEPTION =====
        case TcSdkCallbackResult.exception:
          _stopLoading();
          _show(callback.exception?.message ??
              "Truecaller exception");
          break;

        default:
          break;
      }
    });
  }

  // ================= START TRUECALLER LOGIN =================

  Future<void> startTruecallerLogin() async {

    setState(() => loading = true);

    final usable = await TcSdk.isOAuthFlowUsable;

    if (!usable) {
      _stopLoading();
      _show("Truecaller not installed");
      return;
    }

    /// OAuth state
    _oauthState =
        DateTime.now().millisecondsSinceEpoch.toString();

    TcSdk.setOAuthState(_oauthState!);

    TcSdk.setOAuthScopes([
      'profile',
      'phone',
      'openid',
    ]);

    /// PKCE
    _codeVerifier =
        await TcSdk.generateRandomCodeVerifier;

    final challenge =
        await TcSdk.generateCodeChallenge(_codeVerifier!);

    if (challenge == null) {
      _stopLoading();
      _show("Unsupported device");
      return;
    }

    TcSdk.setCodeChallenge(challenge);

    /// ✅ SDK v1.2.0 CORRECT CALL
    unawaited(TcSdk.getAuthorizationCode);
  }

  // ================= BACKEND TOKEN EXCHANGE =================

  Future<void> _exchangeTokenWithBackend(
      String authCode,
      String verifier) async {

    try {

      /// TODO: Replace with real API call
      await Future.delayed(const Duration(seconds: 1));

      debugPrint("Backend exchange success");

      _stopLoading();
      _goHome();

    } catch (_) {
      _stopLoading();
      _show("Login failed");
    }
  }

  // ================= FIREBASE OTP =================

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
        await FirebaseAuth.instance
            .signInWithCredential(cred);
        _goHome();
      },

      verificationFailed: (e) {
        _stopLoading();
        _show(e.message ?? "OTP Failed");
      },

      codeSent: (id, _) {
        _stopLoading();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OtpScreen(verificationId: id),
          ),
        );
      },

      codeAutoRetrievalTimeout: (_) {
        _stopLoading();
      },
    );
  }

  // ================= HELPERS =================

  void _stopLoading() {
    if (mounted) {
      setState(() => loading = false);
    }
  }

  void _goHome() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
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
          mainAxisAlignment:
              MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Login",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Continue with Truecaller or OTP",
              style: TextStyle(color: Colors.white60),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: phoneController,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixText: "+91 ",
                prefixStyle:
                    const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

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

            if (truecallerAvailable) ...[
              const SizedBox(height: 20),
              const Center(
                child: Text("OR",
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.verified_user),
                  label:
                      const Text("Login with Truecaller"),
                  onPressed: loading
                      ? null
                      : startTruecallerLogin,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}