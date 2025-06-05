import 'package:i_wish/data/services/wish_item_service.dart';
import 'package:i_wish/domain/models/wishlist_item.dart';

import '../../../domain/repository/wish_item/wish_item_repository.dart';

class WishItemRepositoryImpl implements WishItemRepository {
  WishItemRepositoryImpl({required this.wishItemService});

  final WishItemService wishItemService;

  @override
  Future<void> createItem(WishlistItem item) async {
    await wishItemService.createItem(item);
    try {} catch (e) {
      print(e);
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      await wishItemService.deleteItem(id);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<WishlistItem>> getItems() async {
    return await wishItemService.getItems();
  }

  @override
  Future<void> updateItem() {
    // TODO: implement updateItem
    throw UnimplementedError();
  }
}
