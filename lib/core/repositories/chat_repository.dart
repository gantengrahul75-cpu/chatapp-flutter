import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/app_error.dart';
import '../services/firestore_chat_service.dart';

/// Chat Repository
class ChatRepository {
  final FirestoreChatService _chatService;

  ChatRepository({required FirestoreChatService chatService})
      : _chatService = chatService;

  Future<String> getOrCreateChat(String userId1, String userId2) async {
    return await _chatService.getOrCreateChat(userId1, userId2);
  }

  Stream<List<ChatModel>> getUserChatsStream(String userId) {
    return _chatService.getUserChatsStream(userId);
  }

  Future<void> sendMessage(
    String chatId,
    String senderId,
    String recipientId,
    String message, {
    String? imageUrl,
  }) async {
    return await _chatService.sendMessage(
      chatId,
      senderId,
      recipientId,
      message,
      imageUrl: imageUrl,
    );
  }

  Stream<List<MessageModel>> getMessagesStream(String chatId) {
    return _chatService.getMessagesStream(chatId);
  }

  Future<void> markMessageAsRead(String messageId) async {
    return await _chatService.markMessageAsRead(messageId);
  }

  Future<void> togglePinChat(String chatId, bool isPinned) async {
    return await _chatService.togglePinChat(chatId, isPinned);
  }

  Future<void> clearChat(String chatId) async {
    return await _chatService.clearChat(chatId);
  }

  Future<void> deleteChat(String chatId) async {
    return await _chatService.deleteChat(chatId);
  }
}
