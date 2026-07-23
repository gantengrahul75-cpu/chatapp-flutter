import '../models/app_error.dart';
import '../services/firestore_block_service.dart';

/// Block Repository
class BlockRepository {
  final FirestoreBlockService _blockService;

  BlockRepository({required FirestoreBlockService blockService})
      : _blockService = blockService;

  Future<void> blockUser(String userId, String blockedUserId) async {
    return await _blockService.blockUser(userId, blockedUserId);
  }

  Future<void> unblockUser(String userId, String blockedUserId) async {
    return await _blockService.unblockUser(userId, blockedUserId);
  }

  Stream<List<String>> getBlockedUsersStream(String userId) {
    return _blockService.getBlockedUsersStream(userId);
  }

  Future<bool> isUserBlocked(String userId, String otherUserId) async {
    return await _blockService.isUserBlocked(userId, otherUserId);
  }
}
