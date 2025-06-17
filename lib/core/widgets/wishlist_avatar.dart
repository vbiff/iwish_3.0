import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WishListAvatar extends StatelessWidget {
  const WishListAvatar(
      {super.key, required this.pictureUrl, required this.nameShortcut});

  final String pictureUrl;
  final String nameShortcut;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: AppTheme.primaryColor,
      child: pictureUrl.isEmpty
          ? Text(
              nameShortcut,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlack,
              ),
            )
          : ClipOval(
              child: SizedBox(
                height: AppTheme.pictureLength,
                width: AppTheme.pictureLength,
                child: Image.network(
                  pictureUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    size: AppTheme.pictureLength * 0.6,
                    color: AppTheme.primaryBlack,
                  ),
                ),
              ),
            ),
    );
  }
}
