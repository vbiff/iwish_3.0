import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../../domain/core/result.dart';
import '../../../domain/models/wishlist_item.dart';
import '../../../domain/repository/wish_item/wish_item_repository.dart';

class WishItemNotifier extends StateNotifier<WishlistItem> {
  WishItemNotifier(
    this._itemRepository,
  ) : super(WishlistItem(id: '', wishlistId: '', title: ''));

  final WishItemRepository _itemRepository;

  Future<void> createItem(WishlistItem item) async {
    final result = await _itemRepository.createItem(item);
    result.fold(
      (_) => AppLogger.info('Item created successfully: ${item.title}'),
      (failure) => AppLogger.error('Failed to create item: ${failure.message}'),
    );
  }

  Future<void> updateItem(WishlistItem item) async {
    final result = await _itemRepository.updateItem(item);
    result.fold(
      (_) => AppLogger.info('Item updated successfully: ${item.title}'),
      (failure) => AppLogger.error('Failed to update item: ${failure.message}'),
    );
  }

  Future<void> deleteItem(String id) async {
    final result = await _itemRepository.deleteItem(id);
    result.fold(
      (_) => AppLogger.info('Item deleted successfully: $id'),
      (failure) => AppLogger.error('Failed to delete item: ${failure.message}'),
    );
  }
}
