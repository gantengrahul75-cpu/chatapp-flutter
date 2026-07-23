import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_error.dart';
import '../constants/app_constants.dart';

/// Firestore Block Service
class FirestoreBlockService {
  final FirebaseFirestore _firestore;

  FirestoreBlockService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  /// Block user
  Future<void> blockUser(String userId, String blockedUserId) async {
    try {
      final blockId = '${userId}_$blockedUserId';
      await _firestore
          .collection(AppConstants.blockedUsersCollection)
          .doc(blockId)
          .set({
        'userId': userId,
        'blockedUserId': blockedUserId,
        'blockedAt': DateTime.now(),
      });
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to block user',
        originalError: e,
      );
    }
  }

  /// Unblock user
  Future<void> unblockUser(String userId, String blockedUserId) async {
    try {
      final blockId = '${userId}_$blockedUserId';
      await _firestore
          .collection(AppConstants.blockedUsersCollection)
          .doc(blockId)
          .delete();
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to unblock user',
        originalError: e,
      );
    }
  }

  /// Get blocked users stream
  Stream<List<String>> getBlockedUsersStream(String userId) {
    try {
      return _firestore
          .collection(AppConstants.blockedUsersCollection)
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => doc['blockedUserId'] as String)
              .toList());
    } catch (e) {
      return Stream.error(FirestoreError(
        message: 'Failed to get blocked users',
        originalError: e,
      ));
    }
  }

  /// Check if user is blocked
  Future<bool> isUserBlocked(String userId, String otherUserId) async {
    try {
      final blockId = '${userId}_$otherUserId';
      final doc = await _firestore
          .collection(AppConstants.blockedUsersCollection)
          .doc(blockId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
