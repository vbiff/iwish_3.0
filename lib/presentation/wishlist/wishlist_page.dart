import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:i_wish/presentation/wishlist/wish_item/wish_item_provider.dart';
import 'package:i_wish/presentation/item/item_page.dart';

import '../../domain/models/wishlist_item.dart';
import '../home/items/items_provider.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({
    super.key,
    required this.wishlist,
    this.title,
  });

  final List<WishlistItem> wishlist;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemProvider = ref.read(wishItemProvider.notifier);
    final listNotifier = ref.read(itemListProvider.notifier);
    final currentItems = ref.watch(itemListProvider);

    Widget content = ListView.separated(
      itemCount: currentItems.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        return Slidable(
          endActionPane: ActionPane(motion: BehindMotion(), children: [
            SlidableAction(
              onPressed: (context) async {
                await itemProvider.deleteItem(currentItems[index].id!);
                await listNotifier.getItems();
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ]),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ItemPage(
                    item: currentItems[index],
                  ),
                ),
              );
            },
            title: Text(currentItems[index].title),
          ),
        );
      },
    );

    if (currentItems.isEmpty) {
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
