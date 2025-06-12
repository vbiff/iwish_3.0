import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/domain/core/result.dart';

import '../../../core/utils/logger.dart';
import '../../../domain/models/wishlists.dart';
import '../../../domain/repository/wishlist_repository/wishlist_repository.dart';
import 'wishlist_provider.dart';

class WishlistAsyncNotifier extends AsyncNotifier<List<Wishlist>> {
  late WishlistRepository _wishlistRepository;

  @override
  Future<List<Wishlist>> build() async {
    _wishlistRepository = ref.read(wishlistRepositoryProvider);
    return await _getWishlists();
  }

  Future<List<Wishlist>> _getWishlists() async {
    final result = await _wishlistRepository.getWishlists();
    return result.fold(
      (wishlists) => wishlists,
      (failure) {
        AppLogger.error('Failed to get wishlists: ${failure.message}');
        throw failure;
      },
    );
  }

  Future<void> createWishlist(Wishlist wishlist) async {
    final result = await _wishlistRepository.createWishlist(wishlist);
    result.fold(
      (_) {
        AppLogger.info('Wishlist created successfully, refreshing list');
        ref.invalidateSelf();
      },
      (failure) {
        AppLogger.error('Failed to create wishlist: ${failure.message}');
        throw failure;
      },
    );
  }

  Future<void> deleteWishlist(String id) async {
    final result = await _wishlistRepository.deleteWishlist(id);
    result.fold(
      (_) => ref.invalidateSelf(),
      (failure) {
        AppLogger.error('Failed to delete wishlist: ${failure.message}');
        throw failure;
      },
    );
  }

  Future<void> updateWishlist(Wishlist updatedWishlist) async {
    final result = await _wishlistRepository.updateWishlist(updatedWishlist);
    result.fold(
      (_) {
        AppLogger.info('Wishlist updated successfully, refreshing list');
        ref.invalidateSelf();
      },
      (failure) {
        AppLogger.error('Failed to update wishlist: ${failure.message}');
        throw failure;
      },
    );
  }
}
