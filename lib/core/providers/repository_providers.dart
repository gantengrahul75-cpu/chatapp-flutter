import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/chat_repository.dart';
import '../repositories/block_repository.dart';
import 'service_providers.dart';

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    authService: ref.watch(firebaseAuthServiceProvider),
    userService: ref.watch(firestoreUserServiceProvider),
  );
});

/// User Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(
    userService: ref.watch(firestoreUserServiceProvider),
  );
});

/// Chat Repository Provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    chatService: ref.watch(fireStoreChatServiceProvider),
  );
});

/// Block Repository Provider
final blockRepositoryProvider = Provider<BlockRepository>((ref) {
  return BlockRepository(
    blockService: ref.watch(firestoreBlockServiceProvider),
  );
});
