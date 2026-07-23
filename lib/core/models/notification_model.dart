import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Notification Model
class NotificationModel extends Equatable {
  final String notificationId;
  final String userId;
  final String fromUserId;
  final String title;
  final String body;
  final String? chatId;
  final String? groupId;
  final DateTime createdAt;
  final bool isRead;

  const NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.fromUserId,
    required this.title,
    required this.body,
    this.chatId,
    this.groupId,
    required this.createdAt,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
    notificationId,
    userId,
    fromUserId,
    title,
    body,
    chatId,
    groupId,
    createdAt,
    isRead,
  ];

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'fromUserId': fromUserId,
      'title': title,
      'body': body,
      'chatId': chatId,
      'groupId': groupId,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notificationId'] ?? '',
      userId: map['userId'] ?? '',
      fromUserId: map['fromUserId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      chatId: map['chatId'],
      groupId: map['groupId'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }
}
