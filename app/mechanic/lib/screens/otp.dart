import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/navigation/app_router.dart';


class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final otpController = TextEditingController();
  bool loading = false;

  Future<void> verifyOtp() async {

    if (otpController.text.length != 6) {
      _show("Enter valid OTP");
      return;
    }

    setState(() => loading = true);

    final credential =
        PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otpController.text.trim(),
    );

    final userCredential =
        await FirebaseAuth.instance
            .signInWithCredential(credential);

    final uid = userCredential.user!.uid;

    final userDoc = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(uid)
        .get();

    if (!userDoc.exists) {

      final phone = userCredential.user?.phoneNumber ?? '';
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.completeProfile,
        (route) => false,
        arguments: phone,
      );

    } else {

      Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Enter OTP",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style:
                    const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: loading ? null : verifyOtp,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Verify"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}