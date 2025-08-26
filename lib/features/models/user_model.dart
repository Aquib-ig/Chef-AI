import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String email;
  final String name;
  final String? profilePicUrl;
  final DateTime? createdAt;

  UserModel({
    this.uid,
    required this.email,
    required this.name,
    this.profilePicUrl,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profilePicUrl': profilePicUrl,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePicUrl: map['profilePicUrl'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  UserModel copyWith({
    String? uid,
    String? profilePicUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email,
      name: name,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}