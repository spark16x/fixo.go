import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/auth_action_button.dart';
import '../components/auth_text_field.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool isLoginMode = true;

  Future<void> _submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!email.contains('@') || password.length < 6) {
      _show('Enter a valid email and a password (min 6 chars)');
      return;
    }

    setState(() => loading = true);

    try {
      if (isLoginMode) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _show(e.message ?? 'Authentication failed');
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isLoginMode ? 'Login with Email' : 'Create Account',
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              AuthTextField(
                controller: emailController,
                hint: 'Enter email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 14),
              AuthTextField(
                controller: passwordController,
                hint: 'Enter password',
                obscureText: true,
                prefixIcon: Icons.lock,
              ),
              const SizedBox(height: 20),
              AuthActionButton(
                onPressed: _submit,
                loading: loading,
                label: isLoginMode ? 'Login' : 'Sign up',
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: loading
                    ? null
                    : () {
                        setState(() => isLoginMode = !isLoginMode);
                      },
                child: Text(
                  isLoginMode
                      ? 'New here? Create account'
                      : 'Already have an account? Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
