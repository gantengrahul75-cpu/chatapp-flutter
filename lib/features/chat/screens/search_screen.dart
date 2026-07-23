import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/providers/user_provider.dart';
import '../../features/widgets/custom_text_field.dart';
import '../../features/widgets/user_avatar.dart';
import '../../features/widgets/shimmer_loading.dart';

/// Search Screen
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchUsersNotifier = ref.watch(searchUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.searchUsersTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomTextField(
              controller: _searchController,
              hint: AppStrings.searchPlaceholder,
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) {
                setState(() => _searchQuery = value);
                ref.read(searchUsersProvider.notifier).searchUsers(value);
              },
            ),
          ),
          Expanded(
            child: searchUsersNotifier.when(
              data: (users) {
                if (_searchQuery.isEmpty) {
                  return Center(
                    child: Text(
                      AppStrings.searchPlaceholder,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person_search,
                          size: 64,
                          color: AppColors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.noResults,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: UserAvatar(
                        username: user.username,
                        photoUrl: user.photoUrl,
                        isOnline: user.isOnline,
                      ),
                      title: Text(user.username),
                      subtitle: Text(user.email),
                      trailing: ElevatedButton(
                        onPressed: () => context.push('/chat?userId=${user.userId}'),
                        child: const Text(AppStrings.startChat),
                      ),
                    );
                  },
                );
              },
              loading: () => ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      ShimmerLoading(
                        height: 48,
                        width: 48,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerLoading(
                              height: 16,
                              width: 100,
                            ),
                            const SizedBox(height: 8),
                            ShimmerLoading(
                              height: 14,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
