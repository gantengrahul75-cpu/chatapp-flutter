import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'repository_providers.dart';
import 'auth_provider.dart';

/// User Chats Stream Provider
final userChatsStreamProvider = StreamProvider<List<ChatModel>>((ref) async* {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    yield [];
    return;
  }

  final chatRepo = ref.watch(chatRepositoryProvider);
  yield* chatRepo.getUserChatsStream(userId);
});

/// Messages Stream Provider
final messagesStreamProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, chatId) async* {
  final chatRepo = ref.watch(chatRepositoryProvider);
  yield* chatRepo.getMessagesStream(chatId);
});

/// Send Message Notifier
class SendMessageNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRepository chatRepository;

  SendMessageNotifier({required this.chatRepository})
      : super(const AsyncValue.data(null));

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String recipientId,
    required String message,
    String? imageUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      await chatRepository.sendMessage(
        chatId,
        senderId,
        recipientId,
        message,
        imageUrl: imageUrl,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

/// Send Message Provider
final sendMessageProvider =
    StateNotifierProvider<SendMessageNotifier, AsyncValue<void>>((ref) {
  return SendMessageNotifier(
    chatRepository: ref.watch(chatRepositoryProvider),
  );
});

/// Pin Chat Notifier
class PinChatNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRepository chatRepository;

  PinChatNotifier({required this.chatRepository})
      : super(const AsyncValue.data(null));

  Future<void> togglePin(String chatId, bool isPinned) async {
    state = const AsyncValue.loading();
    try {
      await chatRepository.togglePinChat(chatId, isPinned);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

/// Pin Chat Provider
final pinChatProvider =
    StateNotifierProvider<PinChatNotifier, AsyncValue<void>>((ref) {
  return PinChatNotifier(
    chatRepository: ref.watch(chatRepositoryProvider),
  );
});

/// Clear Chat Notifier
class ClearChatNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRepository chatRepository;

  ClearChatNotifier({required this.chatRepository})
      : super(const AsyncValue.data(null));

  Future<void> clearChat(String chatId) async {
    state = const AsyncValue.loading();
    try {
      await chatRepository.clearChat(chatId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

/// Clear Chat Provider
final clearChatProvider =
    StateNotifierProvider<ClearChatNotifier, AsyncValue<void>>((ref) {
  return ClearChatNotifier(
    chatRepository: ref.watch(chatRepositoryProvider),
  );
});

/// Delete Chat Notifier
class DeleteChatNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRepository chatRepository;

  DeleteChatNotifier({required this.chatRepository})
      : super(const AsyncValue.data(null));

  Future<void> deleteChat(String chatId) async {
    state = const AsyncValue.loading();
    try {
      await chatRepository.deleteChat(chatId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

/// Delete Chat Provider
final deleteChatProvider =
    StateNotifierProvider<DeleteChatNotifier, AsyncValue<void>>((ref) {
  return DeleteChatNotifier(
    chatRepository: ref.watch(chatRepositoryProvider),
  );
});
