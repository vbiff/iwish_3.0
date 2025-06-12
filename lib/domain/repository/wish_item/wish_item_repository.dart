import '../../core/result.dart';
import '../../failures/failure.dart';
import '../../models/wishlist_item.dart';

abstract class WishItemRepository {
  Future<Result<void, Failure>> createItem(WishlistItem item);
  Future<Result<void, Failure>> updateItem(WishlistItem item);
  Future<Result<void, Failure>> deleteItem(String id);
  Future<Result<List<WishlistItem>, Failure>> getItems();
}
