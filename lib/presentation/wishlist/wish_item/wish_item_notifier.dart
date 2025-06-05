import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/wishlist_item.dart';
import '../../../domain/repository/wish_item/wish_item_repository.dart';

class WishItemNotifier extends StateNotifier<WishlistItem> {
  WishItemNotifier(
    this._itemRepository,
  ) : super(WishlistItem(id: '', wishlistId: '', title: ''));

  final WishItemRepository _itemRepository;

  Future<void> createItem(WishlistItem item) async {
    try {
      await _itemRepository.createItem(item);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _itemRepository.deleteItem(id);
      // Refresh the items list after deletion
      await _itemRepository.getItems();
    } catch (e) {
      print(e);
    }
  }
}
