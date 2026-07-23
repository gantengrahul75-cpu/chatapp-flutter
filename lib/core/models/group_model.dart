import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Group Model
class GroupModel extends Equatable {
  final String groupId;
  final String groupName;
  final String? groupPhotoUrl;
  final List<String> memberIds;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String lastMessage;
  final DateTime lastMessageTime;

  const GroupModel({
    required this.groupId,
    required this.groupName,
    this.groupPhotoUrl,
    required this.memberIds,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  @override
  List<Object?> get props => [
    groupId,
    groupName,
    groupPhotoUrl,
    memberIds,
    createdBy,
    createdAt,
    updatedAt,
    lastMessage,
    lastMessageTime,
  ];

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupPhotoUrl': groupPhotoUrl,
      'memberIds': memberIds,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map['groupId'] ?? '',
      groupName: map['groupName'] ?? '',
      groupPhotoUrl: map['groupPhotoUrl'],
      memberIds: List<String>.from(map['memberIds'] ?? []),
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  GroupModel copyWith({
    String? groupId,
    String? groupName,
    String? groupPhotoUrl,
    List<String>? memberIds,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) {
    return GroupModel(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      groupPhotoUrl: groupPhotoUrl ?? this.groupPhotoUrl,
      memberIds: memberIds ?? this.memberIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }
}
