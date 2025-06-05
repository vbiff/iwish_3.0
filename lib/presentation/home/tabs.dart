import 'package:flutter/material.dart';
import 'package:i_wish/presentation/auth/profile/profile_page.dart';
import 'package:i_wish/presentation/home/home_page.dart';
import 'package:i_wish/presentation/home/widget/name_screen.dart';
import 'package:i_wish/presentation/item/favorites/favorites_provider.dart';
import 'package:i_wish/presentation/home/items/items_provider.dart';
import 'package:i_wish/presentation/wishlist/wishlist_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/draggable_bottom_sheet.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = HomePage();
    var activePageTitle = 'Home';

    if (_selectedPageIndex == 1) {
      final favoritesItems = ref.watch(favoriteProvider);
      activePage = WishlistPage(
        wishlist: favoritesItems,
      );
      activePageTitle = 'Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
              icon: Icon(
                Icons.person,
              )),
        ),
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'wishlists'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Make a wish'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            useSafeArea: true,
            builder: (BuildContext context) {
              return DraggableBottomSheet(
                child: NameScreen(
                  onPressed: () {
                    ref.read(itemListProvider.notifier).getItems();
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
