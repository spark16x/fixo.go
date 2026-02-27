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

  // ================= TRUECALLER CALLBACK LISTENER =================

  void _listenTruecaller() {
    _tcStream = TcSdk.streamCallbackData.listen((res) {

      switch (res.result) {

        // ===== OAuth Success =====
        case TcSdkCallbackResult.success:

          final authCode =
              res.tcOAuthData?.authorizationCode;

          debugPrint("Truecaller AuthCode: $authCode");

          setState(() => loading = false);

          // Normally send authCode to backend
          _goHome();
          break;

        // ===== Manual Verification Required =====
        case TcSdkCallbackResult.verification:

          final phone = phoneController.text.trim();

          if (phone.length != 10) {
            _show("Enter phone number first");
            setState(() => loading = false);
            return;
          }

          TcSdk.requestVerification(
            phoneNumber: "+91$phone",
          );
          break;

        // ===== Verification Started =====
        case TcSdkCallbackResult.otpInitiated:
        case TcSdkCallbackResult.imOtpInitiated:
        case TcSdkCallbackResult.missedCallInitiated:
          _show("Verification started");
          break;

        // ===== OTP Auto Received =====
        case TcSdkCallbackResult.otpReceived:

          final otp = res.otp;

          if (otp != null) {
            TcSdk.verifyOtp(
              firstName: "User",
              lastName: "",
              otp: otp,
            );
          }
          break;

        // ===== Missed Call Verification =====
        case TcSdkCallbackResult.missedCallReceived:

          TcSdk.verifyMissedCall(
            firstName: "User",
            lastName: "",
          );
          break;

        // ===== Final Success =====
        case TcSdkCallbackResult.verificationComplete:

          debugPrint("AccessToken: ${res.accessToken}");

          setState(() => loading = false);
          _goHome();
          break;

        // ===== Already Verified =====
        case TcSdkCallbackResult.verifiedBefore:

          debugPrint(
              "Verified: ${res.profile?.phoneNumber}");

          setState(() => loading = false);
          _goHome();
          break;

        // ===== Failure =====
        case TcSdkCallbackResult.failure:
          setState(() => loading = false);
          _show(res.error?.message ?? "Truecaller Failed");
          break;

        // ===== Exception =====
        case TcSdkCallbackResult.exception:
          setState(() => loading = false);
          _show(res.exception?.message ?? "Exception");
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
      setState(() => loading = false);
      _show("Truecaller not installed or unsupported");
      return;
    }

    _oauthState =
        DateTime.now().millisecondsSinceEpoch.toString();

    TcSdk.setOAuthState(_oauthState!);

    TcSdk.setOAuthScopes([
      'profile',
      'phone',
      'openid',
    ]);

    _codeVerifier =
        await TcSdk.generateRandomCodeVerifier;

    final challenge =
        await TcSdk.generateCodeChallenge(_codeVerifier!);

    if (challenge == null) {
      setState(() => loading = false);
      _show("Unsupported device");
      return;
    }

    TcSdk.setCodeChallenge(challenge);

    // IMPORTANT: do not await
    TcSdk.getAuthorizationCode();
  }

  // ================= FIREBASE OTP LOGIN =================

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
        setState(() => loading = false);
        _show(e.message ?? "OTP Failed");
      },

      codeSent: (id, _) {
        setState(() => loading = false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OtpScreen(verificationId: id),
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,

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

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "OR",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.verified_user),
                label:
                    const Text("Login with Truecaller"),
                onPressed:
                    loading ? null : startTruecallerLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}