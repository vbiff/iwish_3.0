import 'package:flutter/material.dart';

class DraggableBottomSheet extends StatelessWidget {
  const DraggableBottomSheet({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DraggableScrollableSheet(
        expand: false,
        snap: true,
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        snapSizes: const [0.3, 0.6, 0.9],
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
