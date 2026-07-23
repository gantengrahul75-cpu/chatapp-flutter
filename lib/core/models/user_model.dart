import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// User Model untuk Firebase
class UserModel extends Equatable {
  final String userId;
  final String username;
  final String email;
  final String? photoUrl;
  final bool isOnline;
  final DateTime lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.userId,
    required this.username,
    required this.email,
    this.photoUrl,
    required this.isOnline,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    photoUrl,
    isOnline,
    lastSeen,
    createdAt,
    updatedAt,
  ];

  /// Convert UserModel to Map (untuk Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Convert Map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      isOnline: map['isOnline'] ?? false,
      lastSeen: (map['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Copy with
  UserModel copyWith({
    String? userId,
    String? username,
    String? email,
    String? photoUrl,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
