import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../request/data/service_request_repository.dart';

class QuotesPage extends StatelessWidget {
  const QuotesPage({super.key, required this.requestId});
  final String requestId;

  @override
  Widget build(BuildContext context) {
    final repo = ServiceRequestRepository(FirebaseFirestore.instance);
    return Scaffold(
      appBar: AppBar(title: const Text('Quotes')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: repo.watchQuotes(requestId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('Waiting for mechanic quotes...'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              return ListTile(
                title: Text('Mechanic: ${data['mechanicName'] ?? docs[index].id}'),
                subtitle: Text('ETA ${data['etaMinutes'] ?? '--'} min • ₹${data['proposedPrice'] ?? '--'}'),
              );
            },
          );
        },
      ),
    );
  }
}
