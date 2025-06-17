class WishlistItem {
  const WishlistItem({
    this.id,
    required this.wishlistId,
    required this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String wishlistId;
  final String title;
  final String? description;
  final String? price;
  final String? imageUrl;
  final String? url;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WishlistItem copyWith({
    String? id,
    String? wishlistId,
    String? title,
    String? Function()? description,
    String? Function()? price,
    String? Function()? imageUrl,
    String? Function()? url,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      wishlistId: wishlistId ?? this.wishlistId,
      title: title ?? this.title,
      description: description != null ? description() : this.description,
      price: price != null ? price() : this.price,
      imageUrl: imageUrl != null ? imageUrl() : this.imageUrl,
      url: url != null ? url() : this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Factory constructor for empty/new items
  factory WishlistItem.empty({required String wishlistId}) {
    return WishlistItem(
      wishlistId: wishlistId,
      title: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Factory constructor from JSON/Map
  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    return WishlistItem(
      id: map['id']?.toString(),
      wishlistId: map['wishlist_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString(),
      price: map['price']?.toString(),
      imageUrl: map['image_url']?.toString(),
      url: map['url']?.toString(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wishlist_id': wishlistId,
      'title': title,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'url': url,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Business logic methods
  bool get isEmpty => title.trim().isEmpty;
  bool get isValid => title.trim().isNotEmpty && wishlistId.isNotEmpty;
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasUrl => url != null && url!.isNotEmpty;
  bool get hasPrice => price != null && price!.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          wishlistId == other.wishlistId &&
          title == other.title &&
          description == other.description &&
          price == other.price &&
          imageUrl == other.imageUrl &&
          url == other.url &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      wishlistId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      price.hashCode ^
      imageUrl.hashCode ^
      url.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'WishlistItem(id: $id, title: $title, wishlistId: $wishlistId)';
  }
}
