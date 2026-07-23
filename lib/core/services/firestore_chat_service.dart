import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/app_error.dart';
import '../constants/app_constants.dart';

/// Firestore Chat Service
class FirestoreChatService {
  final FirebaseFirestore _firestore;

  FirestoreChatService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  /// Get or create chat
  Future<String> getOrCreateChat(String userId1, String userId2) async {
    try {
      final chatId =
          _generateChatId(userId1, userId2);

      final doc = await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .get();

      if (!doc.exists) {
        await _firestore
            .collection(AppConstants.chatsCollection)
            .doc(chatId)
            .set({
          'chatId': chatId,
          'userId1': userId1,
          'userId2': userId2,
          'lastMessage': '',
          'lastMessageTime': DateTime.now(),
          'unreadCount': 0,
          'isPinned': false,
          'createdAt': DateTime.now(),
        });
      }

      return chatId;
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to get or create chat',
        originalError: e,
      );
    }
  }

  /// Get user chats stream
  Stream<List<ChatModel>> getUserChatsStream(String userId) {
    try {
      return _firestore
          .collection(AppConstants.chatsCollection)
          .where('userId1', isEqualTo: userId)
          .orderBy('isPinned', descending: true)
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromMap(doc.data()))
              .toList());
    } catch (e) {
      return Stream.error(FirestoreError(
        message: 'Failed to get chats',
        originalError: e,
      ));
    }
  }

  /// Send message
  Future<void> sendMessage(
    String chatId,
    String senderId,
    String recipientId,
    String message, {
    String? imageUrl,
  }) async {
    try {
      final messageId =
          _firestore.collection(AppConstants.messagesCollection).doc().id;
      final now = DateTime.now();

      // Add message
      await _firestore
          .collection(AppConstants.messagesCollection)
          .doc(messageId)
          .set({
        'messageId': messageId,
        'chatId': chatId,
        'senderId': senderId,
        'recipientId': recipientId,
        'text': message,
        'timestamp': now,
        'isRead': false,
        'imageUrl': imageUrl,
      });

      // Update chat last message
      await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .update({
        'lastMessage': message,
        'lastMessageTime': now,
      });
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to send message',
        originalError: e,
      );
    }
  }

  /// Get messages stream
  Stream<List<MessageModel>> getMessagesStream(String chatId) {
    try {
      return _firestore
          .collection(AppConstants.messagesCollection)
          .where('chatId', isEqualTo: chatId)
          .orderBy('timestamp', descending: true)
          .limit(AppConstants.messagesPerPage)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList());
    } catch (e) {
      return Stream.error(FirestoreError(
        message: 'Failed to get messages',
        originalError: e,
      ));
    }
  }

  /// Mark message as read
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _firestore
          .collection(AppConstants.messagesCollection)
          .doc(messageId)
          .update({'isRead': true});
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to mark message as read',
        originalError: e,
      );
    }
  }

  /// Pin/Unpin chat
  Future<void> togglePinChat(String chatId, bool isPinned) async {
    try {
      await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .update({'isPinned': !isPinned});
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to toggle pin chat',
        originalError: e,
      );
    }
  }

  /// Clear chat
  Future<void> clearChat(String chatId) async {
    try {
      final messages = await _firestore
          .collection(AppConstants.messagesCollection)
          .where('chatId', isEqualTo: chatId)
          .get();

      for (var doc in messages.docs) {
        await doc.reference.delete();
      }

      await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .update({
        'lastMessage': '',
        'lastMessageTime': DateTime.now(),
      });
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to clear chat',
        originalError: e,
      );
    }
  }

  /// Delete chat
  Future<void> deleteChat(String chatId) async {
    try {
      // Delete all messages
      final messages = await _firestore
          .collection(AppConstants.messagesCollection)
          .where('chatId', isEqualTo: chatId)
          .get();

      for (var doc in messages.docs) {
        await doc.reference.delete();
      }

      // Delete chat
      await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .delete();
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to delete chat',
        originalError: e,
      );
    }
  }

  /// Generate chat ID
  String _generateChatId(String userId1, String userId2) {
    if (userId1.compareTo(userId2) < 0) {
      return '${userId1}_$userId2';
    } else {
      return '${userId2}_$userId1';
    }
  }
}
