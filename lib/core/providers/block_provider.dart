import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository_providers.dart';
import 'auth_provider.dart';

/// Blocked Users Stream Provider
final blockedUsersStreamProvider = StreamProvider<List<String>>((ref) async* {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    yield [];
    return;
  }

  final blockRepo = ref.watch(blockRepositoryProvider);
  yield* blockRepo.getBlockedUsersStream(userId);
});

/// Block User Notifier
class BlockUserNotifier extends StateNotifier<AsyncValue<void>> {
  final BlockRepository blockRepository;

  BlockUserNotifier({required this.blockRepository})
      : super(const AsyncValue.data(null));

  Future<void> blockUser(String userId, String blockedUserId) async {
    state = const AsyncValue.loading();
    try {
      await blockRepository.blockUser(userId, blockedUserId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

/// Block User Provider
final blockUserProvider =
    StateNotifierProvider<BlockUserNotifier, AsyncValue<void>>((ref) {
  return BlockUserNotifier(
    blockRepository: ref.watch(blockRepositoryProvider),
  );
});

/// Unblock User Notifier
class UnblockUserNotifier extends StateNotifier<AsyncValue<void>> {
  final BlockRepository blockRepository;

  UnblockUserNotifier({required this.blockRepository})
      : super(const AsyncValue.data(null));

  Future<void> unblockUser(String userId, String blockedUserId) async {
    state = const AsyncValue.loading();
    try {
      await blockRepository.unblockUser(userId, blockedUserId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

/// Unblock User Provider
final unblockUserProvider =
    StateNotifierProvider<UnblockUserNotifier, AsyncValue<void>>((ref) {
  return UnblockUserNotifier(
    blockRepository: ref.watch(blockRepositoryProvider),
  );
});

/// Check if User Blocked Provider
final isUserBlockedProvider =
    FutureProvider.family<bool, String>((ref, userId) async {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return false;

  final blockRepo = ref.watch(blockRepositoryProvider);
  return blockRepo.isUserBlocked(currentUserId, userId);
});
