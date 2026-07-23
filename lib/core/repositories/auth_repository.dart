import '../models/user_model.dart';
import '../models/app_error.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_user_service.dart';

/// Auth Repository
class AuthRepository {
  final FirebaseAuthService _authService;
  final FirestoreUserService _userService;

  AuthRepository({
    required FirebaseAuthService authService,
    required FirestoreUserService userService,
  })
      : _authService = authService,
        _userService = userService;

  Stream<dynamic> get authStateChanges => _authService.authStateChanges;

  dynamic get currentUser => _authService.currentUser;

  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    return await _authService.register(
      email: email,
      password: password,
      username: username,
    );
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    return await _authService.login(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    return await _authService.logout();
  }

  Future<void> resetPassword(String email) async {
    return await _authService.resetPassword(email);
  }

  Future<bool> checkUsernameAvailable(String username) async {
    return await _authService.checkUsernameAvailable(username);
  }
}
