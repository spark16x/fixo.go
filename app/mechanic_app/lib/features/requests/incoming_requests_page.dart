import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IncomingRequestsPage extends StatelessWidget {
  const IncomingRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incoming Requests')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('service_requests')
            .where('status', isEqualTo: 'searching')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No active requests'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              return ListTile(
                title: Text(data['serviceType']?.toString() ?? 'Unknown service'),
                subtitle: Text('Status: ${data['status']}'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await docs[index].reference
                        .collection('quotes')
                        .doc('demo_mechanic')
                        .set({
                      'mechanicId': 'demo_mechanic',
                      'proposedPrice': 499,
                      'etaMinutes': 18,
                      'distanceKm': 4.3,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                  },
                  child: const Text('Send Quote'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
