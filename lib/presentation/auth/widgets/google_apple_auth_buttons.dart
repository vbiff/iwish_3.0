import 'package:flutter/material.dart';

import '../../../../../core/ui/styles.dart';

class GoogeAppleAuthButtons extends StatelessWidget {
  const GoogeAppleAuthButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          child: Container(
            height: 100,
            width: 170,
            decoration: BoxDecoration(
              color: AppStyles.textField,
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Apple ID'),
                  Text(
                    'A',
                    style: TextStyle(fontSize: 32),
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          child: Container(
            height: 100,
            width: 170,
            decoration: BoxDecoration(
              color: AppStyles.textField,
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Google'),
                  Text(
                    'G',
                    style: TextStyle(fontSize: 32),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
