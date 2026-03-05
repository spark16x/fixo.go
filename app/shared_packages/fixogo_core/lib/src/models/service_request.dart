import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequest {
  ServiceRequest({
    required this.id,
    required this.userId,
    required this.status,
    required this.serviceType,
    required this.pickupLocation,
    required this.createdAt,
    this.mechanicId,
    this.agreedPrice,
  });

  final String id;
  final String userId;
  final String serviceType;
  final String status;
  final GeoPoint pickupLocation;
  final Timestamp createdAt;
  final String? mechanicId;
  final num? agreedPrice;

  factory ServiceRequest.fromMap(String id, Map<String, dynamic> map) {
    return ServiceRequest(
      id: id,
      userId: map['userId'] as String,
      serviceType: map['serviceType'] as String,
      status: map['status'] as String,
      pickupLocation: map['pickupLocation'] as GeoPoint,
      createdAt: map['createdAt'] as Timestamp,
      mechanicId: map['mechanicId'] as String?,
      agreedPrice: map['agreedPrice'] as num?,
    );
  }
}
