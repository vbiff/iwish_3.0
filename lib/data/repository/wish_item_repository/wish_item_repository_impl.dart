import '../../../domain/core/result.dart';
import '../../../domain/failures/failure.dart';
import '../../../domain/models/wishlist_item.dart';
import '../../../domain/repository/wish_item/wish_item_repository.dart';
import '../../services/wish_item_service.dart';

class WishItemRepositoryImpl implements WishItemRepository {
  WishItemRepositoryImpl({required this.wishItemService});

  final WishItemService wishItemService;

  @override
  Future<Result<void, Failure>> createItem(WishlistItem item) async {
    return await wishItemService.createItem(item);
  }

  @override
  Future<Result<void, Failure>> deleteItem(String id) async {
    return await wishItemService.deleteItem(id);
  }

  @override
  Future<Result<List<WishlistItem>, Failure>> getItems() async {
    return await wishItemService.getItems();
  }

  @override
  Future<Result<void, Failure>> updateItem(WishlistItem item) async {
    return await wishItemService.updateItem(item);
  }
}
