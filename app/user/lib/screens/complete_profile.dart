import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/navigation/app_router.dart';

import '../models/user_model.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String phone;

  const CompleteProfileScreen({
    super.key,
    required this.phone,
  });

  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends State<CompleteProfileScreen> {

  final TextEditingController nameController = TextEditingController();

  bool loading = false;

  Future<void> saveProfile() async {

    if (loading) return;

    final name = nameController.text.trim();

    if (name.length < 3) {
      _show("Enter a valid name");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _show("User not authenticated");
      return;
    }

    setState(() => loading = true);

    try {

      final avatarUrl =
          "https://ui-avatars.com/api/?name=$name&background=0D8ABC&color=fff";

      final userModel = UserModel(
        uid: user.uid,
        name: name,
        phone: widget.phone,
        role: "user",
        avatar: avatarUrl,
        createdAt: Timestamp.now(),
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(userModel.toMap());

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);

    } catch (e) {

      _show("Error saving profile");

    } finally {

      if (mounted) {
        setState(() => loading = false);
      }

    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
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
                "Complete Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : saveProfile,
                  child: loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}