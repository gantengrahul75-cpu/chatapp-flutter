/// App Constants
class AppConstants {
  // App Info
  static const String appName = 'ChatApp';
  static const String appVersion = '1.0.0';
  static const String developerName = 'Muhammad Asyfa Ruhullah';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String groupsCollection = 'groups';
  static const String blockedUsersCollection = 'blocked_users';
  static const String savedUsersCollection = 'saved_users';
  static const String notificationsCollection = 'notifications';
  
  // Firestore Fields
  static const String userIdField = 'userId';
  static const String usernameField = 'username';
  static const String emailField = 'email';
  static const String photoUrlField = 'photoUrl';
  static const String createdAtField = 'createdAt';
  static const String updatedAtField = 'updatedAt';
  static const String lastMessageField = 'lastMessage';
  static const String lastMessageTimeField = 'lastMessageTime';
  static const String unreadCountField = 'unreadCount';
  static const String isOnlineField = 'isOnline';
  static const String lastSeenField = 'lastSeen';
  static const String isBlockedField = 'isBlocked';
  static const String isPinnedField = 'isPinned';
  static const String messageTextField = 'text';
  static const String senderIdField = 'senderId';
  static const String recipientIdField = 'recipientId';
  static const String messageTimeField = 'timestamp';
  static const String isReadField = 'isRead';
  
  // Validation
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int minMessageLength = 1;
  static const int maxMessageLength = 1000;
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int messagesPerPage = 20;
  static const int chatsPerPage = 50;
}
