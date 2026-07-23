import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../core/models/user_model.dart';

/// User Avatar Widget
class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String username;
  final double size;
  final bool isOnline;

  const UserAvatar({
    Key? key,
    this.photoUrl,
    required this.username,
    this.size = 48,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            image: photoUrl != null
                ? DecorationImage(
                    image: NetworkImage(photoUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: photoUrl == null
              ? Center(
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onlineGreen,
                border: Border.all(
                  color: AppColors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
