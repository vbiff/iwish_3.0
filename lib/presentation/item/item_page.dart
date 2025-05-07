import 'package:flutter/material.dart';

import 'package:i_wish/domain/models/wishlist_item.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({
    super.key,
    required this.item,
  });

  final WishlistItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Card(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).hoverColor,
          ),
          child: Text(item.title),
        ),
      ),
    );
  }
}
