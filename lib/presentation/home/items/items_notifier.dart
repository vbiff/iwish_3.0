import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../../domain/core/result.dart';
import '../../../domain/models/wishlist_item.dart';
import '../../../domain/repository/wish_item/wish_item_repository.dart';
import 'items_provider.dart';

class ItemsAsyncNotifier extends AsyncNotifier<List<WishlistItem>> {
  late WishItemRepository _itemRepository;

  @override
  Future<List<WishlistItem>> build() async {
    _itemRepository = ref.read(wishItemRepositoryProvider);
    return await _getItems();
  }

  Future<List<WishlistItem>> _getItems() async {
    final result = await _itemRepository.getItems();
    return result.fold(
      (items) => items,
      (failure) {
        AppLogger.error('Failed to get items: ${failure.message}');
        throw failure;
      },
    );
  }

  Future<void> createItem(WishlistItem item) async {
    final result = await _itemRepository.createItem(item);
    result.fold(
      (_) => refresh(),
      (failure) {
        AppLogger.error('Failed to create item: ${failure.message}');
        throw failure;
      },
    );
  }

  Future<void> deleteItem(String id) async {
    final result = await _itemRepository.deleteItem(id);
    result.fold(
      (_) => refresh(),
      (failure) {
        AppLogger.error('Failed to delete item: ${failure.message}');
        throw failure;
      },
    );
  }

  Future<void> updateItem(WishlistItem item) async {
    final result = await _itemRepository.updateItem(item);
    result.fold(
      (_) => refresh(),
      (failure) {
        AppLogger.error('Failed to update item: ${failure.message}');
        throw failure;
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _getItems());
  }
}
