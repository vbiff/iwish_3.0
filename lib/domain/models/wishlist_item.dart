import 'package:flutter/widgets.dart';

class WishlistItem {
  final String? id;
  final String? wishlistId;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? url;

  WishlistItem({
    this.id,
    this.wishlistId,
    required this.title,
    this.description,
    this.imageUrl,
    this.url,
  });

  WishlistItem copyWith({
    String? id,
    String? wishlistId,
    String? title,
    ValueGetter<String?>? description,
    ValueGetter<String?>? imageUrl,
    ValueGetter<String?>? url,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      wishlistId: wishlistId ?? this.wishlistId,
      title: title ?? this.title,
      description: description != null ? description() : this.description,
      imageUrl: imageUrl != null ? imageUrl() : this.imageUrl,
      url: url != null ? url() : this.url,
    );
  }
}
