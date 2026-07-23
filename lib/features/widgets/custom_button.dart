import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

/// Custom Button Widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final IconData? icon;
  final EdgeInsets padding;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height = 48,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          disabledBackgroundColor: AppColors.grey,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppColors.white,
                  ),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, color: textColor ?? AppColors.white), const SizedBox(width: 8),],
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor ?? AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
