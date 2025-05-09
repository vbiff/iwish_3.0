import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/avatar_background.jpg'),
        radius: 100,
      ),
    );
  }
}
