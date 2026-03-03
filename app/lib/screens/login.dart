import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';
import 'package:uuid/uuid.dart';

import 'otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final phoneController = TextEditingController();
  final phoneFocus = FocusNode();

  bool loading = false;

  /// TRUECALLER STATE (UNCHANGED)
  bool truecallerAvailable = false;
  bool checkingTruecaller = true;
  StreamSubscription? _tcStream;
  String? _codeVerifier;
  String? _oauthState;

  @override
  void initState() {
    super.initState();
    _initializeTruecaller();
  }

  // ================= PHONE AUTH =================

  Future<void> authenticate() async {

    final phone = phoneController.text.trim();

    if (phone.length != 10) {
      _show("Enter valid 10 digit number");
      return;
    }

    setState(() => loading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91$phone",

      verificationCompleted: (credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential);
      },

      verificationFailed: (e) {
        _stopLoading();
        _show(e.message ?? "Verification failed");
      },

      codeSent: (verificationId, _) {
        _stopLoading();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OtpScreen(verificationId: verificationId),
          ),
        );
      },

      codeAutoRetrievalTimeout: (_) {
        _stopLoading();
      },
    );
  }

  // ================= TRUECALLER (UNCHANGED) =================

  Future<void> _initializeTruecaller() async {
    TcSdk.initializeSDK(
      sdkOption: TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS,
    );

    final usable = await TcSdk.isOAuthFlowUsable;

    if (!mounted) return;

    truecallerAvailable = usable;
    checkingTruecaller = false;

    if (usable) _listenTruecaller();

    setState(() {});
  }

  void _listenTruecaller() {
    _tcStream =
        TcSdk.streamCallbackData.listen((callback) async {

      if (callback.result ==
          TcSdkCallbackResult.success) {

        final data = callback.tcOAuthData;

        if (data == null ||
            data.state != _oauthState ||
            _codeVerifier == null) {
          _show("Truecaller validation failed");
          return;
        }

        // TODO: Send to backend & create Firestore user
      }
    });
  }

  void _stopLoading() {
    if (mounted) setState(() => loading = false);
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    phoneController.dispose();
    phoneFocus.dispose();
    _tcStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Login with Phone",
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: phoneController,
              focusNode: phoneFocus,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixText: "+91 ",
                prefixStyle:
                    const TextStyle(color: Colors.white),
                hintText: "Enter phone number",
                hintStyle:
                    const TextStyle(color: Colors.white54),
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
                onPressed: loading ? null : authenticate,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Send OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}