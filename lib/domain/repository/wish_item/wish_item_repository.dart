import 'package:i_wish/domain/models/wishlist_item.dart';

abstract class WishItemRepository {
  Future<void> createItem(WishlistItem item);
  Future<void> updateItem();
  Future<void> deleteItem(String id);
  Future<List<WishlistItem>> getItems();
}
