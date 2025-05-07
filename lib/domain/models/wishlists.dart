import 'package:flutter/material.dart';

class Wishlist {
  Wishlist({
    required this.id,
    required this.title,
    this.description = '',
    required this.createdAt,
    this.color = Colors.orange,
  });

  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final Color color;
}
