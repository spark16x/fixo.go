import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  final String uid;
  final String name;
  final String phone;
  final String role;
  final String avatar;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.role,
    required this.avatar,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "phone": phone,
      "role": role,
      "avatar": avatar,
      "createdAt": createdAt,
    };
  }

  factory UserModel.fromMap(
      Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"],
      name: map["name"],
      phone: map["phone"],
      role: map["role"],
      avatar: map["avatar"],
      createdAt: map["createdAt"],
    );
  }
}