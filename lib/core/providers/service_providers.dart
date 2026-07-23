import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_user_service.dart';
import '../services/firestore_chat_service.dart';
import '../services/firestore_block_service.dart';
import '../services/fcm_service.dart';

/// Firebase Auth Provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Firestore Provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Firebase Messaging Provider
final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

/// Firebase Auth Service Provider
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

/// Firestore User Service Provider
final firestoreUserServiceProvider = Provider<FirestoreUserService>((ref) {
  return FirestoreUserService(
    firestore: ref.watch(firestoreProvider),
  );
});

/// Firestore Chat Service Provider
final fireStoreChatServiceProvider = Provider<FirestoreChatService>((ref) {
  return FirestoreChatService(
    firestore: ref.watch(firestoreProvider),
  );
});

/// Firestore Block Service Provider
final firestoreBlockServiceProvider = Provider<FirestoreBlockService>((ref) {
  return FirestoreBlockService(
    firestore: ref.watch(firestoreProvider),
  );
});

/// FCM Service Provider
final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService(
    firebaseMessaging: ref.watch(firebaseMessagingProvider),
  );
});
