import 'package:flutter/material.dart';
import 'otp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your phone number to continue',
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 30),

            // Phone input
            TextField(
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixText: '+91 ',
                prefixStyle: const TextStyle(color: Colors.white),
                hintText: 'Phone Number',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Continue button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: "+91$phone", // get from controller
                    verificationCompleted: (credential) async {
                      await FirebaseAuth.instance.signInWithCredential(credential);
                      
                    },
                    verificationFailed: (e) {
                      debugPrint(e.message);
                      
                    },
                    codeSent: (verificationId, _) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OtpScreen(verificationId: verificationId)
                          
                        ),
                        
                      );
                      
                    },
                    codeAutoRetrievalTimeout: (_) {},
                    
                  );
                  
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
