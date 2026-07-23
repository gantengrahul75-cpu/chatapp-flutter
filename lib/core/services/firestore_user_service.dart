import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/app_error.dart';
import '../constants/app_constants.dart';

/// Firestore User Service
class FirestoreUserService {
  final FirebaseFirestore _firestore;

  FirestoreUserService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  /// Get user by ID
  Future<UserModel> getUserById(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (!doc.exists) {
        throw FirestoreError(message: 'User not found');
      }

      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to get user',
        originalError: e,
      );
    }
  }

  /// Get user by username
  Future<UserModel> getUserByUsername(String username) async {
    try {
      final query = await _firestore
          .collection(AppConstants.usersCollection)
          .where(AppConstants.usernameField, isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw FirestoreError(message: 'User not found');
      }

      return UserModel.fromMap(
          query.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to get user',
        originalError: e,
      );
    }
  }

  /// Search users by username
  Stream<List<UserModel>> searchUsersByUsername(String query) {
    try {
      if (query.isEmpty) {
        return Stream.value([]);
      }

      return _firestore
          .collection(AppConstants.usersCollection)
          .where(AppConstants.usernameField,
              isGreaterThanOrEqualTo: query,
              isLessThan: '${query}z')
          .limit(20)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList());
    } catch (e) {
      return Stream.error(FirestoreError(
        message: 'Search failed',
        originalError: e,
      ));
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now();
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update(data);
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to update profile',
        originalError: e,
      );
    }
  }

  /// Update username
  Future<void> updateUsername(String userId, String newUsername) async {
    try {
      // Check if username available
      final query = await _firestore
          .collection(AppConstants.usersCollection)
          .where(AppConstants.usernameField, isEqualTo: newUsername)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        throw ValidationError(message: 'Username already taken');
      }

      await updateUserProfile(userId, {
        AppConstants.usernameField: newUsername,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get online status stream
  Stream<bool> getOnlineStatus(String userId) {
    try {
      return _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .snapshots()
          .map((snapshot) => snapshot.data()?['isOnline'] as bool? ?? false);
    } catch (e) {
      return Stream.error(FirestoreError(
        message: 'Failed to get online status',
        originalError: e,
      ));
    }
  }

  /// Get total users count
  Future<int> getTotalUsersCount() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Stream total users count (real-time)
  Stream<int> streamTotalUsersCount() {
    try {
      return _firestore
          .collection(AppConstants.usersCollection)
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    } catch (e) {
      return Stream.value(0);
    }
  }
}
