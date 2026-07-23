import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

/// Message Bubble Widget
class MessageBubble extends StatelessWidget {
  final String message;
  final bool isOwn;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isOwn,
    required this.timestamp,
    required this.isRead,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isOwn ? AppColors.primary : AppColors.greyLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(
                  color: isOwn ? AppColors.white : AppColors.black,
                  fontSize: 14,
                ),
              ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '12:30',
                  style: TextStyle(
                    color: isOwn ? AppColors.white : AppColors.grey,
                    fontSize: 12,
                  ),
                ),
                if (isOwn) ...[const SizedBox(width: 4), Icon(Icons.done_all, size: 14, color: isRead ? AppColors.white : AppColors.grey),],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
