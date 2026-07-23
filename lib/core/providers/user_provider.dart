import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'repository_providers.dart';

/// Search Users Notifier
class SearchUsersNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final UserRepository userRepository;

  SearchUsersNotifier({required this.userRepository})
      : super(const AsyncValue.data([]));

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      userRepository.searchUsersByUsername(query).listen((users) {
        state = AsyncValue.data(users);
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

/// Search Users Provider
final searchUsersProvider =
    StateNotifierProvider<SearchUsersNotifier, AsyncValue<List<UserModel>>>(
        (ref) {
  return SearchUsersNotifier(
    userRepository: ref.watch(userRepositoryProvider),
  );
});

/// Get User by Username Provider
final getUserByUsernameProvider =
    FutureProvider.family<UserModel, String>((ref, username) async {
  final userRepo = ref.watch(userRepositoryProvider);
  return userRepo.getUserByUsername(username);
});

/// Check Username Available Provider
final checkUsernameAvailableProvider =
    FutureProvider.family<bool, String>((ref, username) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.checkUsernameAvailable(username);
});

/// Get Total Users Count Provider
final totalUsersCountProvider = FutureProvider<int>((ref) async {
  final userRepo = ref.watch(userRepositoryProvider);
  return userRepo.getTotalUsersCount();
});

/// Stream Total Users Count Provider
final totalUsersCountStreamProvider = StreamProvider<int>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  return userRepo.streamTotalUsersCount();
});

/// Get Online Status Provider
final onlineStatusProvider =
    StreamProvider.family<bool, String>((ref, userId) {
  final userRepo = ref.watch(userRepositoryProvider);
  return userRepo.getOnlineStatus(userId);
});
