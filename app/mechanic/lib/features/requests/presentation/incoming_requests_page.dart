import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IncomingRequestsPage extends StatelessWidget {
  const IncomingRequestsPage({super.key});

  Future<void> _submitQuote(String requestId, BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('service_requests')
        .doc(requestId)
        .collection('quotes')
        .doc(uid)
        .set({
      'mechanicId': uid,
      'mechanicName': 'Mechanic $uid',
      'proposedPrice': 499,
      'etaMinutes': 18,
      'distanceKm': 4.2,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quote submitted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incoming Requests')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('service_requests')
            .where('status', isEqualTo: 'searching')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('No incoming requests'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              return Card(
                child: ListTile(
                  title: Text('Service: ${data['serviceType'] ?? '-'}'),
                  subtitle: Text('Status: ${data['status'] ?? '-'}'),
                  trailing: FilledButton(
                    onPressed: () => _submitQuote(docs[index].id, context),
                    child: const Text('Quote'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
