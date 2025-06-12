import 'package:flutter/material.dart';
import '../../domain/models/wishlist_color.dart';

class ColorMapper {
  static Color toFlutterColor(WishlistColor wishlistColor) {
    return switch (wishlistColor) {
      WishlistColor.orange => Colors.orange,
      WishlistColor.blue => Colors.blue,
      WishlistColor.green => Colors.green,
      WishlistColor.purple => Colors.purple,
      WishlistColor.red => Colors.red,
      WishlistColor.yellow => Colors.yellow,
      WishlistColor.pink => Colors.pink,
      WishlistColor.teal => Colors.teal,
    };
  }

  static WishlistColor fromFlutterColor(Color color) {
    if (color == Colors.orange) return WishlistColor.orange;
    if (color == Colors.blue) return WishlistColor.blue;
    if (color == Colors.green) return WishlistColor.green;
    if (color == Colors.purple) return WishlistColor.purple;
    if (color == Colors.red) return WishlistColor.red;
    if (color == Colors.yellow) return WishlistColor.yellow;
    if (color == Colors.pink) return WishlistColor.pink;
    if (color == Colors.teal) return WishlistColor.teal;

    return WishlistColor.orange; // default
  }
}
