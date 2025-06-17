import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/core/result.dart';
import '../../domain/models/wishlist_item.dart';
import '../../domain/repository/wish_item/wish_item_repository.dart';
import '../utils/logger.dart';
import '../providers/app_providers.dart';

/// AsyncNotifier for managing wishlist items
/// Follows Single Responsibility Principle - only manages item operations
class ItemsNotifier extends AsyncNotifier<List<WishlistItem>> {
  late WishItemRepository _repository;

  @override
  Future<List<WishlistItem>> build() async {
    // Dependency injection through Riverpod
    _repository = ref.read(wishItemRepositoryProvider);

    // Load initial items
    return await _loadItems();
  }

  /// Load items from repository
  Future<List<WishlistItem>> _loadItems() async {
    final result = await _repository.getItems();
    return result.fold(
      (items) {
        AppLogger.info('Loaded ${items.length} items');
        return items;
      },
      (failure) {
        AppLogger.error('Failed to load items: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Create a new item
  Future<void> createItem(WishlistItem item) async {
    state = const AsyncLoading();

    try {
      final result = await _repository.createItem(item);

      await result.fold(
        (_) async {
          // Refresh the list to get the updated data
          await refresh();
          AppLogger.info('Item created successfully: ${item.title}');
        },
        (failure) async {
          AppLogger.error('Failed to create item: ${failure.message}');
          // Restore previous state and show error
          state = AsyncError(failure, StackTrace.current);
        },
      );
    } catch (error, _) {
      AppLogger.error('Unexpected error creating item: $error');
      state = AsyncError(error, StackTrace.current);
    }
  }

  /// Update an existing item
  Future<void> updateItem(WishlistItem item) async {
    // Keep current data visible while updating
    final currentState = state;

    try {
      final result = await _repository.updateItem(item);

      await result.fold(
        (_) async {
          // Refresh the list to get the updated data
          await refresh();
          AppLogger.info('Item updated successfully: ${item.title}');
        },
        (failure) async {
          AppLogger.error('Failed to update item: ${failure.message}');
          // Restore previous state and show error
          state = currentState;
          throw failure;
        },
      );
    } catch (error, _) {
      AppLogger.error('Unexpected error updating item: $error');
      state = currentState; // Restore previous state
      rethrow;
    }
  }

  /// Delete an item
  Future<void> deleteItem(String id) async {
    // Keep current data visible while deleting
    final currentState = state;

    try {
      final result = await _repository.deleteItem(id);

      await result.fold(
        (_) async {
          // Refresh the list to reflect the deletion
          await refresh();
          AppLogger.info('Item deleted successfully: $id');
        },
        (failure) async {
          AppLogger.error('Failed to delete item: ${failure.message}');
          // Restore previous state and show error
          state = currentState;
          throw failure;
        },
      );
    } catch (error, _) {
      AppLogger.error('Unexpected error deleting item: $error');
      state = currentState; // Restore previous state
      rethrow;
    }
  }

  /// Refresh the items list
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadItems);
  }

  /// Get a specific item by ID
  WishlistItem? getItemById(String id) {
    return state.value?.where((item) => item.id == id).firstOrNull;
  }

  /// Get items for a specific wishlist
  List<WishlistItem> getItemsForWishlist(String wishlistId) {
    return state.value
            ?.where((item) => item.wishlistId == wishlistId)
            .toList() ??
        [];
  }

  /// Get items count for a specific wishlist
  int getItemsCountForWishlist(String wishlistId) {
    return getItemsForWishlist(wishlistId).length;
  }

  /// Search items by title
  List<WishlistItem> searchItems(String query) {
    if (query.isEmpty) return state.value ?? [];

    final lowercaseQuery = query.toLowerCase();
    return state.value
            ?.where((item) =>
                item.title.toLowerCase().contains(lowercaseQuery) ||
                (item.description?.toLowerCase().contains(lowercaseQuery) ??
                    false))
            .toList() ??
        [];
  }

  /// Filter items by various criteria
  List<WishlistItem> filterItems({
    String? wishlistId,
    bool? hasImage,
    bool? hasUrl,
    bool? hasPrice,
  }) {
    var items = state.value ?? <WishlistItem>[];

    if (wishlistId != null) {
      items = items.where((item) => item.wishlistId == wishlistId).toList();
    }

    if (hasImage != null) {
      items = items.where((item) => item.hasImage == hasImage).toList();
    }

    if (hasUrl != null) {
      items = items.where((item) => item.hasUrl == hasUrl).toList();
    }

    if (hasPrice != null) {
      items = items.where((item) => item.hasPrice == hasPrice).toList();
    }

    return items;
  }

  /// Bulk operations

  /// Delete all items for a specific wishlist
  Future<void> deleteItemsForWishlist(String wishlistId) async {
    final itemsToDelete = getItemsForWishlist(wishlistId);

    for (final item in itemsToDelete) {
      if (item.id != null) {
        await deleteItem(item.id!);
      }
    }
  }

  /// Move items to another wishlist
  Future<void> moveItemsToWishlist(
      List<String> itemIds, String targetWishlistId) async {
    for (final itemId in itemIds) {
      final item = getItemById(itemId);
      if (item != null) {
        final updatedItem = item.copyWith(
          wishlistId: targetWishlistId,
          updatedAt: DateTime.now(),
        );
        await updateItem(updatedItem);
      }
    }
  }
}
