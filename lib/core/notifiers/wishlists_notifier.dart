import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/core/result.dart';
import '../../domain/models/wishlists.dart';
import '../../domain/repository/wishlist_repository/wishlist_repository.dart';
import '../utils/logger.dart';

/// AsyncNotifier for managing wishlists
/// Follows Single Responsibility Principle - only manages wishlist operations
class WishlistsNotifier extends AsyncNotifier<List<Wishlist>> {
  late WishlistRepository _repository;

  @override
  Future<List<Wishlist>> build() async {
    // Dependency injection through Riverpod
    _repository = ref.read(wishlistRepositoryProvider);

    // Load initial wishlists
    return await _loadWishlists();
  }

  /// Load wishlists from repository
  Future<List<Wishlist>> _loadWishlists() async {
    final result = await _repository.getWishlists();
    return result.fold(
      (wishlists) {
        AppLogger.info('Loaded ${wishlists.length} wishlists');
        return wishlists;
      },
      (failure) {
        AppLogger.error('Failed to load wishlists: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Create a new wishlist
  Future<void> createWishlist(Wishlist wishlist) async {
    state = const AsyncLoading();

    try {
      final result = await _repository.createWishlist(wishlist);

      await result.fold(
        (_) async {
          // Refresh the list to get the updated data
          await refresh();
          AppLogger.info('Wishlist created successfully: ${wishlist.title}');
        },
        (failure) async {
          AppLogger.error('Failed to create wishlist: ${failure.message}');
          // Restore previous state and show error
          state = AsyncError(failure, StackTrace.current);
        },
      );
    } catch (error, _) {
      AppLogger.error('Unexpected error creating wishlist: $error');
      state = AsyncError(error, StackTrace.current);
    }
  }

  /// Update an existing wishlist
  Future<void> updateWishlist(Wishlist wishlist) async {
    // Keep current data visible while updating
    final currentState = state;

    try {
      final result = await _repository.updateWishlist(wishlist);

      await result.fold(
        (_) async {
          // Refresh the list to get the updated data
          await refresh();
          AppLogger.info('Wishlist updated successfully: ${wishlist.title}');
        },
        (failure) async {
          AppLogger.error('Failed to update wishlist: ${failure.message}');
          // Restore previous state and show error
          state = currentState;
          throw failure;
        },
      );
    } catch (error, _) {
      AppLogger.error('Unexpected error updating wishlist: $error');
      state = currentState; // Restore previous state
      rethrow;
    }
  }

  /// Delete a wishlist
  Future<void> deleteWishlist(String id) async {
    // Keep current data visible while deleting
    final currentState = state;

    try {
      final result = await _repository.deleteWishlist(id);

      await result.fold(
        (_) async {
          // Refresh the list to reflect the deletion
          await refresh();
          AppLogger.info('Wishlist deleted successfully: $id');
        },
        (failure) async {
          AppLogger.error('Failed to delete wishlist: ${failure.message}');
          // Restore previous state and show error
          state = currentState;
          throw failure;
        },
      );
    } catch (error, _) {
      AppLogger.error('Unexpected error deleting wishlist: $error');
      state = currentState; // Restore previous state
      rethrow;
    }
  }

  /// Refresh the wishlists list
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadWishlists);
  }

  /// Get a specific wishlist by ID
  Wishlist? getWishlistById(String id) {
    return state.value?.where((w) => w.id == id).firstOrNull;
  }

  /// Get wishlists for a specific user
  List<Wishlist> getWishlistsForUser(String userId) {
    return state.value?.where((w) => w.userId == userId).toList() ?? [];
  }
}

// Placeholder provider - will be properly defined in app_providers.dart
final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  throw UnimplementedError('This should be implemented in app_providers.dart');
});
