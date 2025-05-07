import 'package:flutter/material.dart';
import 'package:i_wish/data/dummy/list_wishlists.dart';
import 'package:i_wish/presentation/home/widget/wishlist_folder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IWish'),
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisExtent: 120,
        ),
        children: [
          for (final wishlist in wishlists)
            WishlistFolder(wishlist: wishlist, id: wishlist.id),
        ],
      ),
    );
  }
}
