import '../../core/result.dart';
import '../../failures/failure.dart';
import '../../models/wishlists.dart';

abstract class WishlistRepository {
  Future<Result<List<Wishlist>, Failure>> getWishlists();
  Future<Result<void, Failure>> createWishlist(Wishlist wishlist);
  Future<Result<void, Failure>> updateWishlist(Wishlist wishlist);
  Future<Result<void, Failure>> deleteWishlist(String id);
}
