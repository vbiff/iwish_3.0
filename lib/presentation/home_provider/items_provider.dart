import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/data/repository/wish_item_repository/wish_item_repository_impl.dart';
import 'package:i_wish/domain/repository/wish_item/wish_item_repository.dart';

import '../../domain/models/wishlist_item.dart';

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

final wishItemProviderFromSupabase = Provider<WishItemRepository>((ref) {
  return WishItemRepositoryImpl();
});

final itemListProvider =
    StateNotifierProvider<ItemFromSupabaseNotifier, List<WishlistItem>>((ref) {
  final wishItemRepo = ref.read(wishItemProviderFromSupabase);
  return ItemFromSupabaseNotifier(wishItemRepo);
});
