import 'package:flutter/material.dart';
import 'package:i_wish/data/dummy/list_wishlists.dart';

import 'package:i_wish/domain/models/wishlists.dart';
import 'package:i_wish/presentation/item/item_page.dart';

import '../../domain/models/wishlist_item.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({
    super.key,
    required this.wishlist,
  });

  final Wishlist wishlist;

  @override
  Widget build(BuildContext context) {
    final List<WishlistItem> currentWishlist =
        wishlistItems.where((w) => wishlist.id == w.id).toList();
    Widget content = ListView.separated(
      itemCount: currentWishlist.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ItemPage(
                  item: wishlistItems
                      .where((w) => wishlist.id == w.id)
                      .toList()[index],
                ),
              ),
            );
          },
          title: Text(wishlistItems
              .where((w) => wishlist.id == w.id)
              .toList()[index]
              .title),
        );
      },
    );

    if (currentWishlist.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('There are no wishes so far'),
            Text(
              'Make you wish!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(wishlist.title),
      ),
      body: content,
    );
  }
}
