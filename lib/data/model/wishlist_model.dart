import '../../domain/models/wishlist_color.dart';
import '../../domain/models/wishlists.dart';

class WishlistModel {
  WishlistModel({
    required this.id,
    required this.title,
    required this.userId,
    required this.createdAt,
    this.color = WishlistColor.orange,
  });

  final String id;
  final String title;
  final String userId;
  final DateTime createdAt;
  final WishlistColor color;

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'].toString(), // Convert to string (could be int or string)
      title: json['title'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      color: WishlistColor.fromString(json['color'] as String? ?? 'orange'),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'color': color.value,
    };

    // Only include ID if it's not empty (for updates, not inserts)
    if (id.isNotEmpty) {
      json['id'] = id;
    }

    return json;
  }

  Wishlist toEntity() {
    return Wishlist(
      id: id,
      title: title,
      userId: userId,
      createdAt: createdAt,
      color: color,
    );
  }

  factory WishlistModel.fromEntity(Wishlist wishlist) {
    return WishlistModel(
      id: wishlist.id,
      title: wishlist.title,
      userId: wishlist.userId,
      createdAt: wishlist.createdAt,
      color: wishlist.color,
    );
  }
}
