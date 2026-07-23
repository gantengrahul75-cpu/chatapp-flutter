import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

/// Loading Shimmer Widget
class ShimmerLoading extends StatefulWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const ShimmerLoading({
    Key? key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            color: Color.lerp(
              AppColors.greyLight,
              Colors.grey[300],
              _controller.value,
            ),
          ),
        );
      },
    );
  }
}
