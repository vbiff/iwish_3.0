import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:i_wish/data/dummy/list_wishlists.dart';
import 'package:i_wish/presentation/home/widget/wishlist_folder.dart';

import '../home_provider/items_provider.dart';
import '../wishlist/wishlist_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(itemListProvider.notifier).getItems();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(itemListProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisExtent: 120,
        ),
        children: [
          InkWell(
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WishlistPage(
                    wishlist: items,
                    title: 'All my wishes',
                  ),
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
                    Theme.of(context)
                        .colorScheme
                        .onInverseSurface
                        .withAlpha(255),
                    Theme.of(context)
                        .colorScheme
                        .onTertiaryFixed
                        .withAlpha(150),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'All my wishes',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ),
          for (final wishlist in wishlists)
            WishlistFolder(
              wishlist: wishlist,
              id: wishlist.id,
            ),
          InkWell(
            onTap: () => {},
            splashColor: Theme.of(context).splashColor,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.onPrimary.withAlpha(255),
                    Theme.of(context).colorScheme.onPrimary.withAlpha(150),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'Add new Wishlist',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
