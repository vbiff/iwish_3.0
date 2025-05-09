import 'package:flutter/material.dart';

import '../ui/styles.dart';

class WishlistAvatarWidget extends StatelessWidget {
  const WishlistAvatarWidget({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Red top widget
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: AppStyles.pictureLength,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.6,
                colors: [
                  color,
                  AppStyles.primaryColor,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
