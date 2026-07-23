import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/app_error.dart';
import '../constants/app_constants.dart';

/// Firebase Authentication Service
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthService({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })
      : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  /// Get current user stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Register dengan email dan password
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Validasi username unik
      await _validateUsernameUnique(username);

      // Create user auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      // Create user document di Firestore
      final userModel = UserModel(
        userId: userId,
        username: username,
        email: email,
        photoUrl: null,
        isOnline: true,
        lastSeen: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthError(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw AuthError(
        message: 'Registration failed',
        originalError: e,
      );
    }
  }

  /// Login dengan email dan password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      // Get user data dari Firestore
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw AuthError(message: 'User data not found');
      }

      // Update online status
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'isOnline': true,
        'lastSeen': DateTime.now(),
      });

      return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      throw AuthError(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw AuthError(
        message: 'Login failed',
        originalError: e,
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId != null) {
        // Update online status to false
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .update({
          'isOnline': false,
          'lastSeen': DateTime.now(),
        });
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthError(
        message: 'Logout failed',
        originalError: e,
      );
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthError(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw AuthError(
        message: 'Reset password failed',
        originalError: e,
      );
    }
  }

  /// Validasi username unik
  Future<void> _validateUsernameUnique(String username) async {
    try {
      final query = await _firestore
          .collection(AppConstants.usersCollection)
          .where(AppConstants.usernameField, isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        throw ValidationError(message: 'Username already taken');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Check username available
  Future<bool> checkUsernameAvailable(String username) async {
    try {
      final query = await _firestore
          .collection(AppConstants.usersCollection)
          .where(AppConstants.usernameField, isEqualTo: username)
          .limit(1)
          .get();

      return query.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Map Firebase Auth error ke user-friendly message
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password terlalu lemah';
      case 'email-already-in-use':
        return 'Email sudah digunakan';
      case 'invalid-email':
        return 'Email tidak valid';
      case 'user-not-found':
        return 'User tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan, coba lagi nanti';
      default:
        return 'Authentication error';
    }
  }
}
