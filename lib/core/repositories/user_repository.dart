import '../models/user_model.dart';
import '../models/app_error.dart';
import '../services/firestore_user_service.dart';

/// User Repository
class UserRepository {
  final FirestoreUserService _userService;

  UserRepository({required FirestoreUserService userService})
      : _userService = userService;

  Future<UserModel> getUserById(String userId) async {
    return await _userService.getUserById(userId);
  }

  Future<UserModel> getUserByUsername(String username) async {
    return await _userService.getUserByUsername(username);
  }

  Stream<List<UserModel>> searchUsersByUsername(String query) {
    return _userService.searchUsersByUsername(query);
  }

  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    return await _userService.updateUserProfile(userId, data);
  }

  Future<void> updateUsername(String userId, String newUsername) async {
    return await _userService.updateUsername(userId, newUsername);
  }

  Stream<bool> getOnlineStatus(String userId) {
    return _userService.getOnlineStatus(userId);
  }

  Future<int> getTotalUsersCount() async {
    return await _userService.getTotalUsersCount();
  }

  Stream<int> streamTotalUsersCount() {
    return _userService.streamTotalUsersCount();
  }
}
