import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/chat_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../features/widgets/chat_item.dart';
import '../../features/widgets/shimmer_loading.dart';

/// Chats Screen
class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(userChatsStreamProvider);
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.chatsTitle),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: chatsAsync.when(
        data: (chats) {
          if (chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.noChats,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.noChatDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/search'),
                    icon: const Icon(Icons.search),
                    label: const Text('Find Users'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 64,
            ),
            itemBuilder: (context, index) {
              final chat = chats[index];
              final otherUserId =
                  chat.userId1 == userId ? chat.userId2 : chat.userId1;

              return ChatItem(
                username: 'User ${otherUserId.substring(0, 5)}',
                lastMessage: chat.lastMessage,
                unreadCount: chat.unreadCount,
                isPinned: chat.isPinned,
                onTap: () => context.push('/chat/${chat.chatId}'),
                onLongPress: () => _showChatOptions(context, chat.chatId),
              );
            },
          );
        },
        loading: () => ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ShimmerLoading(
                  height: 48,
                  width: 48,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/search'),
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _showChatOptions(BuildContext context, String chatId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.push_pin),
              title: const Text('Pin Chat'),
              onTap: () {
                context.pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: const Text('Clear Chat'),
              onTap: () {
                context.pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text(
                'Delete Chat',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () {
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
