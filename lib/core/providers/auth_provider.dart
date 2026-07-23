import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'repository_providers.dart';

/// Current User State Notifier
class CurrentUserNotifier extends StateNotifier<UserModel?> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  CurrentUserNotifier({
    required this.authRepository,
    required this.userRepository,
  }) : super(null);

  Future<void> fetchCurrentUser(String userId) async {
    try {
      final user = await userRepository.getUserById(userId);
      state = user;
    } catch (e) {
      state = null;
    }
  }

  void updateUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

/// Current User Provider
final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, UserModel?>((ref) {
  return CurrentUserNotifier(
    authRepository: ref.watch(authRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
});

/// Current User ID Provider
final currentUserIdProvider = Provider<String?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.currentUser?.uid;
});

/// Auth State Provider
final authStateProvider = StreamProvider<dynamic>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges;
});
