import 'wishlist_color.dart';

class Wishlist {
  Wishlist({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    this.color = WishlistColor.orange,
  });

  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final WishlistColor color;
}
