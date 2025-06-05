import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/domain/models/wishlist_item.dart';

import 'favorites_notifier.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteItemsNotifier, List<WishlistItem>>((ref) {
  return FavoriteItemsNotifier();
});
