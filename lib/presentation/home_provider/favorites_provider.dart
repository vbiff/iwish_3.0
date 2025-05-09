import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/domain/models/wishlist_item.dart';

class FavoriteItemsNotifier extends StateNotifier<List<WishlistItem>> {
  FavoriteItemsNotifier() : super([]);

  bool toggleWishItemFavorite(WishlistItem item) {
    final isFavorite = state.contains(item);

    if (isFavorite) {
      state = state.where((i) => i.wishlistId != item.wishlistId).toList();
      return false;
    } else {
      state = [...state, item];
      return true;
    }
  }
}

final favoriteProvider =
    StateNotifierProvider<FavoriteItemsNotifier, List<WishlistItem>>((ref) {
  return FavoriteItemsNotifier();
});
