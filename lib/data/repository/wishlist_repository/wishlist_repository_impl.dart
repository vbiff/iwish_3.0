import '../../../domain/repository/wishlist_repository/wishlist_repository.dart';
import '../../../domain/models/wishlists.dart';
import '../../../domain/core/result.dart';
import '../../../domain/failures/failure.dart';
import '../../services/wishlist_service.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  WishlistRepositoryImpl({required this.wishlistService});

  final WishlistService wishlistService;

  @override
  Future<Result<List<Wishlist>, Failure>> getWishlists() async {
    return await wishlistService.getWishlists();
  }

  @override
  Future<Result<void, Failure>> createWishlist(Wishlist wishlist) async {
    return await wishlistService.createWishlist(wishlist);
  }

  @override
  Future<Result<void, Failure>> updateWishlist(Wishlist wishlist) async {
    return await wishlistService.updateWishlist(wishlist);
  }

  @override
  Future<Result<void, Failure>> deleteWishlist(String id) async {
    return await wishlistService.deleteWishlist(id);
  }
}
