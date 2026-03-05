import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isOnline = false;

  Future<void> updateAvailability(bool value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => isOnline = value);
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'role': 'mechanic',
      'isOnline': value,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mechanic Home')),
      body: Column(
        children: [
          SwitchListTile(
            value: isOnline,
            onChanged: updateAvailability,
            title: const Text('Available for jobs'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/incoming'),
            child: const Text('View Incoming Requests'),
          ),
        ],
      ),
    );
  }
}
