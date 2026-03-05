import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  bool loading = false;

  Future<void> createRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => loading = true);
    await FirebaseFirestore.instance.collection('service_requests').add({
      'userId': user.uid,
      'serviceType': 'breakdown',
      'status': 'searching',
      'pickupLocation': const GeoPoint(28.6139, 77.2090),
      'broadcastRadius': 3000,
      'agreedPrice': null,
      'commissionAmount': null,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(
        DateTime.now().add(const Duration(minutes: 5)),
      ),
    });
    if (mounted) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request created. Waiting for quotes...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Request')),
      body: Center(
        child: ElevatedButton(
          onPressed: loading ? null : createRequest,
          child: Text(loading ? 'Creating...' : 'Confirm Request'),
        ),
      ),
    );
  }
}
