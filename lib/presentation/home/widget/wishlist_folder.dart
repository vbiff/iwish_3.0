import 'package:flutter/material.dart';

import 'package:i_wish/presentation/wishlist/wishlist_page.dart';

import '../../../domain/models/wishlists.dart';

class WishlistFolder extends StatelessWidget {
  const WishlistFolder({
    super.key,
    required this.id,
    required this.wishlist,
  });

  final String id;
  final Wishlist wishlist;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WishlistPage(wishlist: wishlist),
          ),
        )
      },
      splashColor: Theme.of(context).splashColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              wishlist.color.withAlpha(255),
              wishlist.color.withAlpha(150),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          wishlist.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
        ),
      ),
    );
  }
}
