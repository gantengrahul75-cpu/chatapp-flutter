import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Message Model
class MessageModel extends Equatable {
  final String messageId;
  final String chatId;
  final String senderId;
  final String recipientId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;

  const MessageModel({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.recipientId,
    required this.text,
    required this.timestamp,
    required this.isRead,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    messageId,
    chatId,
    senderId,
    recipientId,
    text,
    timestamp,
    isRead,
    imageUrl,
  ];

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'senderId': senderId,
      'recipientId': recipientId,
      'text': text,
      'timestamp': timestamp,
      'isRead': isRead,
      'imageUrl': imageUrl,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      recipientId: map['recipientId'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
      imageUrl: map['imageUrl'],
    );
  }

  MessageModel copyWith({
    String? messageId,
    String? chatId,
    String? senderId,
    String? recipientId,
    String? text,
    DateTime? timestamp,
    bool? isRead,
    String? imageUrl,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
