import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/core/result.dart';
import '../../domain/failures/failure.dart';
import '../../domain/models/app_state.dart';
import '../../domain/models/wishlist_item.dart';
import '../../domain/models/wishlists.dart';
import '../../domain/repository/wish_item/wish_item_repository.dart';
import '../../domain/repository/wishlist_repository/wishlist_repository.dart';
import '../utils/logger.dart';
import '../providers/app_providers.dart';

/// Main application notifier that manages the overall app state
/// Follows Single Responsibility Principle by only managing app-wide state
class AppNotifier extends Notifier<AppState> {
  late WishlistRepository _wishlistRepository;
  late WishItemRepository _itemRepository;

  @override
  AppState build() {
    // Dependency injection through Riverpod
    _wishlistRepository = ref.read(wishlistRepositoryProvider);
    _itemRepository = ref.read(wishItemRepositoryProvider);

    // Initialize with empty state
    return AppState.initial();
  }

  /// Load initial data for the application
  Future<void> initialize() async {
    try {
      state = state.setLoading(true);

      // Load both wishlists and items concurrently
      final results = await Future.wait([
        _wishlistRepository.getWishlists(),
        _itemRepository.getItems(),
      ]);

      final wishlistsResult = results[0] as Result<List<Wishlist>, Failure>;
      final itemsResult = results[1] as Result<List<WishlistItem>, Failure>;

      // Handle wishlists result
      final wishlists = wishlistsResult.fold(
        (success) => success,
        (failure) {
          AppLogger.error('Failed to load wishlists: ${failure.message}');
          throw failure;
        },
      );

      // Handle items result
      final items = itemsResult.fold(
        (success) => success,
        (failure) {
          AppLogger.error('Failed to load items: ${failure.message}');
          throw failure;
        },
      );

      // Update state with loaded data
      state = state.copyWith(
        wishlists: wishlists,
        items: items,
        isLoading: false,
      );

      AppLogger.info(
          'App initialized successfully with ${wishlists.length} wishlists and ${items.length} items');
    } catch (error) {
      state = AppState.error(error.toString());
      AppLogger.error('Failed to initialize app: $error');
    }
  }

  /// Refresh all application data
  Future<void> refresh() async {
    await initialize();
  }

  /// Update the entire wishlists list
  void updateWishlists(List<Wishlist> wishlists) {
    state = state.copyWith(wishlists: wishlists);
  }

  /// Update the entire items list
  void updateItems(List<WishlistItem> items) {
    state = state.copyWith(items: items);
  }

  /// Add a new wishlist to the state
  void addWishlist(Wishlist wishlist) {
    state = state.addWishlist(wishlist);
  }

  /// Update an existing wishlist in the state
  void updateWishlist(Wishlist wishlist) {
    state = state.updateWishlist(wishlist);
  }

  /// Remove a wishlist from the state
  void removeWishlist(String wishlistId) {
    state = state.removeWishlist(wishlistId);
  }

  /// Add a new item to the state
  void addItem(WishlistItem item) {
    state = state.addItem(item);
  }

  /// Update an existing item in the state
  void updateItem(WishlistItem item) {
    state = state.updateItem(item);
  }

  /// Remove an item from the state
  void removeItem(String itemId) {
    state = state.removeItem(itemId);
  }

  /// Select a wishlist
  void selectWishlist(String? wishlistId) {
    state = state.selectWishlist(wishlistId);
  }

  /// Clear any error state
  void clearError() {
    state = state.clearError();
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.setLoading(isLoading);
  }
}
