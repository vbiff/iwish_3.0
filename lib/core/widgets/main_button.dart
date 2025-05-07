import 'package:flutter/material.dart';

import '../ui/styles.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.color,
    required this.title,
    required this.onPressed,
  });

  final Color color;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.borderRadius)),
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 44),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: AppStyles.textStyleSoFoSans,
      ),
    );
  }
}
