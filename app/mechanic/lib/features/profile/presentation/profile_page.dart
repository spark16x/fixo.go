import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _workshopController = TextEditingController();

  Future<void> _save() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': _nameController.text.trim(),
      'workshop': _workshopController.text.trim(),
      'phone': user.phoneNumber,
      'role': 'mechanic',
      'isOnline': false,
      'serviceTypes': ['puncture', 'towing', 'battery', 'fuel', 'mechanic_help'],
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mechanic KYC')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _workshopController, decoration: const InputDecoration(labelText: 'Workshop')),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: const Text('Save Profile')),
        ]),
      ),
    );
  }
}
