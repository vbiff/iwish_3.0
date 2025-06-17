import 'wishlist_color.dart';

class Wishlist {
  const Wishlist({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    this.color = WishlistColor.orange,
    this.updatedAt,
    this.description,
    this.isPublic = false,
    this.itemCount = 0,
  });

  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final WishlistColor color;
  final bool isPublic;
  final int itemCount;

  Wishlist copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    WishlistColor? color,
    bool? isPublic,
    int? itemCount,
  }) {
    return Wishlist(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
      isPublic: isPublic ?? this.isPublic,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  // Factory constructor for creating new wishlists
  factory Wishlist.create({
    required String userId,
    required String title,
    String? description,
    WishlistColor color = WishlistColor.orange,
    bool isPublic = false,
  }) {
    final now = DateTime.now();
    return Wishlist(
      id: '', // Will be set by the backend
      userId: userId,
      title: title,
      description: description,
      createdAt: now,
      updatedAt: now,
      color: color,
      isPublic: isPublic,
      itemCount: 0,
    );
  }

  // Factory constructor from JSON/Map
  factory Wishlist.fromMap(Map<String, dynamic> map) {
    return Wishlist(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      color: WishlistColor.values.firstWhere(
        (c) => c.name == map['color'],
        orElse: () => WishlistColor.orange,
      ),
      isPublic: map['is_public'] == true,
      itemCount: map['item_count']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'color': color.name,
      'is_public': isPublic,
      'item_count': itemCount,
    };
  }

  // Business logic methods
  bool get isEmpty => title.trim().isEmpty;
  bool get isValid => title.trim().isNotEmpty && userId.isNotEmpty;
  bool get hasItems => itemCount > 0;
  bool get hasDescription => description != null && description!.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Wishlist &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          description == other.description &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          color == other.color &&
          isPublic == other.isPublic &&
          itemCount == other.itemCount;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      color.hashCode ^
      isPublic.hashCode ^
      itemCount.hashCode;

  @override
  String toString() {
    return 'Wishlist(id: $id, title: $title, itemCount: $itemCount)';
  }
}
