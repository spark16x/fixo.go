import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';
import 'package:uuid/uuid.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  /// ================= CONTROLLERS =================

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool isLogin = true;
  bool loading = false;
  bool obscurePassword = true;

  /// ================= VALIDATION =================

  bool emailValid = false;

  double passwordStrength = 0;
  String strengthText = "";
  Color strengthColor = Colors.grey;

  bool hasLength = false;
  bool hasUpper = false;
  bool hasNumber = false;
  bool hasSpecial = false;

  /// ================= TRUECALLER STATE (UNCHANGED) =================

  bool truecallerAvailable = false;
  bool checkingTruecaller = true;

  StreamSubscription? _tcStream;

  String? _codeVerifier;
  String? _oauthState;

  // ================= INIT =================

  @override
  void initState() {
    super.initState();
    _initializeTruecaller();
  }

  // ================= EMAIL VALIDATION =================

  void _validateEmail(String value) {
    final regex =
        RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$');

    setState(() {
      emailValid = regex.hasMatch(value);
    });
  }

  // ================= PASSWORD CHECK =================

  void _checkPassword(String value) {
    hasLength = value.length >= 8;
    hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    hasNumber = RegExp(r'[0-9]').hasMatch(value);
    hasSpecial =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    double strength = 0;
    if (hasLength) strength += 0.25;
    if (hasUpper) strength += 0.25;
    if (hasNumber) strength += 0.25;
    if (hasSpecial) strength += 0.25;

    setState(() {
      passwordStrength = strength;

      if (strength <= .25) {
        strengthText = "Weak";
        strengthColor = Colors.red;
      } else if (strength <= .5) {
        strengthText = "Fair";
        strengthColor = Colors.orange;
      } else if (strength <= .75) {
        strengthText = "Good";
        strengthColor = Colors.yellow;
      } else {
        strengthText = "Strong";
        strengthColor = Colors.green;
      }
    });
  }

  // ================= TRUECALLER INIT =================

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
          _stopLoading();
          _show("Truecaller validation failed");
          return;
        }

        await _exchangeTokenWithBackend(
          data.authorizationCode,
          _codeVerifier!,
        );
      }
    });
  }

  Future<void> startTruecallerLogin() async {
    setState(() => loading = true);

    _oauthState = const Uuid().v4();
    TcSdk.setOAuthState(_oauthState!);

    TcSdk.setOAuthScopes(
        ['profile', 'phone', 'openid']);

    _codeVerifier =
        await TcSdk.generateRandomCodeVerifier;

    final challenge =
        await TcSdk.generateCodeChallenge(
            _codeVerifier!);

    if (challenge == null) {
      _stopLoading();
      return;
    }

    TcSdk.setCodeChallenge(challenge);
    TcSdk.getAuthorizationCode;
  }

  Future<void> _exchangeTokenWithBackend(
      String code, String verifier) async {
    await Future.delayed(const Duration(seconds: 1));
    _goHome();
  }

  // ================= EMAIL AUTH =================

  Future<void> authenticate() async {

    if (!emailValid) {
      _show("Enter valid email");
      return;
    }

    if (!isLogin && passwordStrength < 0.75) {
      _show("Password too weak");
      return;
    }

    setState(() => loading = true);

    try {
      if (isLogin) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      }

      _goHome();
    } on FirebaseAuthException catch (e) {
      _show(e.message ?? "Auth failed");
      _stopLoading();
    }
  }

  // ================= HELPERS =================

  void _stopLoading() {
    if (mounted) setState(() => loading = false);
  }

  void _goHome() {
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
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
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
        child: ListView(
          children: [

            Text(
              isLogin ? "Login" : "Register",
              style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            /// EMAIL
            TextField(
              controller: emailController,
              focusNode: emailFocus,
              autofocus: true,
              onChanged: _validateEmail,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) =>
                  passwordFocus.requestFocus(),
              style:
                  const TextStyle(color: Colors.white),
              decoration:
                  _input("Email", valid: emailValid),
            ),

            const SizedBox(height: 16),

            /// PASSWORD
            TextField(
              controller: passwordController,
              focusNode: passwordFocus,
              obscureText: obscurePassword,
              onChanged: _checkPassword,
              style:
                  const TextStyle(color: Colors.white),
              decoration: _input(
                "Password",
                suffix: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => setState(
                      () => obscurePassword =
                          !obscurePassword),
                ),
              ),
            ),

            /// PASSWORD STRENGTH
            if (!isLogin &&
                passwordController.text.isNotEmpty) ...[
              const SizedBox(height: 12),

              TweenAnimationBuilder(
                duration:
                    const Duration(milliseconds: 300),
                tween:
                    Tween(begin: 0.0, end: passwordStrength),
                builder: (_, value, __) =>
                    LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: Colors.grey[800],
                  valueColor:
                      AlwaysStoppedAnimation(
                          strengthColor),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Strength: $strengthText",
                style: TextStyle(
                    color: strengthColor),
              ),

              const SizedBox(height: 10),

              _rule("8+ characters", hasLength),
              _rule("Uppercase letter", hasUpper),
              _rule("Number", hasNumber),
              _rule("Special character", hasSpecial),
            ],

            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: loading ? null : authenticate,
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(
                        isLogin ? "Login" : "Register"),
              ),
            ),

            TextButton(
              onPressed: () =>
                  setState(() => isLogin = !isLogin),
              child: Text(isLogin
                  ? "Create account"
                  : "Already have account?"),
            ),

            if (!checkingTruecaller &&
                truecallerAvailable) ...[
              const SizedBox(height: 20),
              const Center(
                  child: Text("OR",
                      style:
                          TextStyle(color: Colors.white))),
              const SizedBox(height: 20),

              OutlinedButton.icon(
                icon:
                    const Icon(Icons.verified_user),
                label:
                    const Text("Login with Truecaller"),
                onPressed:
                    loading ? null : startTruecallerLogin,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  InputDecoration _input(String hint,
      {bool valid = true, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(color: Colors.white54),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey[900],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: valid ? Colors.grey : Colors.red),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _rule(String text, bool ok) {
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.cancel,
          color: ok ? Colors.green : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                color: Colors.white70)),
      ],
    );
  }
}