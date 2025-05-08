class WishlistItem {
  final String id;
  final String wishlistId;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? url;

  WishlistItem({
    required this.id,
    required this.wishlistId,
    required this.title,
    this.description,
    this.imageUrl,
    this.url,
  });
}
