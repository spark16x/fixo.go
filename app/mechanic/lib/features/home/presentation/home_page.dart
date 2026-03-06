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
  bool _online = false;

  Future<void> _toggle(bool value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    setState(() => _online = value);
    await FirebaseFirestore.instance.collection('users').doc(uid).set({'isOnline': value}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIXO.GO Mechanic'),
        actions: [
          IconButton(onPressed: () => context.go('/profile'), icon: const Icon(Icons.person)),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchListTile(value: _online, onChanged: _toggle, title: const Text('Available for jobs')),
            FilledButton(onPressed: () => context.go('/incoming'), child: const Text('View Incoming Requests')),
          ],
        ),
      ),
    );
  }
}
