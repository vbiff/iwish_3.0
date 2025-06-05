import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/wishlist_item.dart';
import '../../../domain/repository/wish_item/wish_item_repository.dart';

class ItemFromSupabaseNotifier extends StateNotifier<List<WishlistItem>> {
  ItemFromSupabaseNotifier(
    this.itemRepository,
  ) : super([]);

  final WishItemRepository itemRepository;

  Future<void> getItems() async {
    try {
      state = await itemRepository.getItems();
      print(state);
    } on Exception catch (e) {
      print(e);
    }
  }
}
