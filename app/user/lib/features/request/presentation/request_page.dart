import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../data/service_request_repository.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String _selected = 'puncture';
  bool _loading = false;

  Future<void> _create() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _loading = true);
    try {
      final position = await Geolocator.getCurrentPosition();
      final repo = ServiceRequestRepository(FirebaseFirestore.instance);
      final requestId = await repo.createRequest(
        userId: user.uid,
        serviceType: _selected,
        lat: position.latitude,
        lng: position.longitude,
      );
      if (mounted) context.go('/quotes/$requestId');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Request')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selected,
              items: const ['puncture', 'towing', 'battery', 'fuel', 'mechanic_help']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => _selected = value ?? _selected),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loading ? null : _create, child: Text(_loading ? 'Creating...' : 'Confirm Request')),
          ],
        ),
      ),
    );
  }
}
