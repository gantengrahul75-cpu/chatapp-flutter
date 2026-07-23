import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/app_error.dart';
import 'package:logger/logger.dart';

/// Firebase Cloud Messaging Service
class FCMService {
  final FirebaseMessaging _firebaseMessaging;
  final Logger _logger = Logger();

  FCMService({required FirebaseMessaging firebaseMessaging})
      : _firebaseMessaging = firebaseMessaging;

  /// Initialize FCM
  Future<void> initialize() async {
    try {
      // Request permission
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carryForward: true,
        critical: false,
        provisional: false,
        sound: true,
      );

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _logger.i('Foreground message: ${message.notification?.title}');
      });

      // Handle background messages
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _logger.i('Message opened app: ${message.notification?.title}');
      });

      // Get FCM token
      final token = await _firebaseMessaging.getToken();
      _logger.i('FCM Token: $token');
    } catch (e) {
      _logger.e('FCM initialization error: $e');
    }
  }

  /// Get FCM token
  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      throw FirestoreError(
        message: 'Failed to get FCM token',
        originalError: e,
      );
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
    } catch (e) {
      _logger.e('Subscribe topic error: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } catch (e) {
      _logger.e('Unsubscribe topic error: $e');
    }
  }
}
