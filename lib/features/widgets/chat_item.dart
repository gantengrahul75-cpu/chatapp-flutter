import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

/// Chat Item Widget
class ChatItem extends StatelessWidget {
  final String username;
  final String lastMessage;
  final String? photoUrl;
  final int unreadCount;
  final bool isPinned;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSwipe;

  const ChatItem({
    Key? key,
    required this.username,
    required this.lastMessage,
    this.photoUrl,
    required this.unreadCount,
    required this.isPinned,
    required this.onTap,
    this.onLongPress,
    this.onSwipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: Stack(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: Center(
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (isPinned)
            Positioned(
              right: 0,
              top: 0,
              child: Icon(
                Icons.pin,
                size: 16,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
      title: Text(
        username,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.grey,
          fontSize: 14,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            '12:30',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 12,
            ),
          ),
          if (unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.unreadBadge,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
