import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_paths.dart';

class ServiceRequestRepository {
  ServiceRequestRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<String> createRequest({
    required String userId,
    required String serviceType,
    required double lat,
    required double lng,
  }) async {
    final doc = _firestore.collection(FirestorePaths.serviceRequests).doc();
    await doc.set({
      'userId': userId,
      'mechanicId': null,
      'serviceType': serviceType,
      'pickupLocation': GeoPoint(lat, lng),
      'status': 'searching',
      'agreedPrice': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchQuotes(String requestId) {
    return _firestore.collection(FirestorePaths.quotes(requestId)).snapshots();
  }
}
