import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:i_wish/domain/models/wishlist_item.dart';
import 'package:i_wish/presentation/home_provider/favorites_provider.dart';

class ItemPage extends ConsumerWidget {
  const ItemPage({
    super.key,
    required this.item,
  });

  final WishlistItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite = ref.watch(favoriteProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        actions: [
          IconButton(
            onPressed: () {
              final isAdded = ref
                  .read(favoriteProvider.notifier)
                  .toggleWishItemFavorite(item);
              if (!isAdded) {
                Navigator.of(context).pop();
              }
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(isAdded
                      ? 'Item is added to favorite'
                      : 'Item is removed from favorite'),
                ),
              );
            },
            icon: Icon(
              favorite.contains(item) ? Icons.star : Icons.star_border,
            ),
          ),
        ],
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
