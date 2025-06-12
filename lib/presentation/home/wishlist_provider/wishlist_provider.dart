import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/wishlist_repository/wishlist_repository_impl.dart';
import '../../../data/services/wishlist_service.dart';
import '../../../domain/models/wishlists.dart';
import '../../../domain/repository/wishlist_repository/wishlist_repository.dart';
import 'wishlist_notifier.dart';

final wishlistServiceProvider = Provider<WishlistService>((ref) {
  return WishlistService();
});

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepositoryImpl(
    wishlistService: ref.read(wishlistServiceProvider),
  );
});

final wishlistsProvider =
    AsyncNotifierProvider<WishlistAsyncNotifier, List<Wishlist>>(
  WishlistAsyncNotifier.new,
);
