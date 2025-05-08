import 'package:flutter/material.dart';
import 'package:i_wish/presentation/item/item_page.dart';

import '../../domain/models/wishlist_item.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({
    super.key,
    required this.wishlist,
    this.title,
  });

  final List<WishlistItem> wishlist;
  final String? title;

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.separated(
      itemCount: wishlist.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ItemPage(
                  item: wishlist[index],
                ),
              ),
            );
          },
          title: Text(wishlist[index].title),
        );
      },
    );

    if (wishlist.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('There are no wishes so far'),
            Text(
              'Make your wish!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      );
    }

    if (title == null) {
      return content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
