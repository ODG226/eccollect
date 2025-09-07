import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isAdmin;
  final String password;

  AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
    this.isAdmin = false,
    required this.password,
  });

  factory AppUser.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isAdmin: data['isAdmin'] ?? false, password: data['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "displayName": displayName,
      "photoUrl": photoUrl,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
      "isAdmin": isAdmin,
      'password': password,
      'id': id,
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
