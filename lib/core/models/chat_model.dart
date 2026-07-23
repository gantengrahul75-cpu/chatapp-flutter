import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Chat Model untuk daftar chat
class ChatModel extends Equatable {
  final String chatId;
  final String userId1;
  final String userId2;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isPinned;
  final DateTime createdAt;

  const ChatModel({
    required this.chatId,
    required this.userId1,
    required this.userId2,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isPinned,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    chatId,
    userId1,
    userId2,
    lastMessage,
    lastMessageTime,
    unreadCount,
    isPinned,
    createdAt,
  ];

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'userId1': userId1,
      'userId2': userId2,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'unreadCount': unreadCount,
      'isPinned': isPinned,
      'createdAt': createdAt,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] ?? '',
      userId1: map['userId1'] ?? '',
      userId2: map['userId2'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCount: map['unreadCount'] ?? 0,
      isPinned: map['isPinned'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  ChatModel copyWith({
    String? chatId,
    String? userId1,
    String? userId2,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isPinned,
    DateTime? createdAt,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      userId1: userId1 ?? this.userId1,
      userId2: userId2 ?? this.userId2,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
