import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';
import 'models/user_model.dart';

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

  final nameController = TextEditingController();
  bool loading = false;

  Future<void> saveProfile() async {

    final name = nameController.text.trim();

    if (name.length < 3) {
      _show("Enter valid name");
      return;
    }

    setState(() => loading = true);

    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;

    final avatarUrl =
        "https://ui-avatars.com/api/?name=$name&background=0D8ABC&color=fff";

    final userModel = UserModel(
      uid: uid,
      name: name,
      phone: widget.phone,
      role: "user",
      avatar: avatarUrl,
      createdAt: Timestamp.now(),
    );

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(userModel.toMap());

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (_) => false,
    );
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
                "Complete Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: nameController,
                style:
                    const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  hintStyle:
                      const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
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
                      ? const CircularProgressIndicator()
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