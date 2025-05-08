import 'package:flutter/material.dart';

import '../../domain/models/wishlist_item.dart';
import '../../domain/models/wishlists.dart';

final List<Wishlist> wishlists = [
  Wishlist(
    id: '1',
    title: 'Wishlist 1',
    description: 'Wishlist 1 description',
    createdAt: DateTime.now(),
    color: Colors.red,
  ),
  Wishlist(
    id: '2',
    title: 'Wishlist 2',
    description: 'Wishlist 2 description',
    createdAt: DateTime.now(),
    color: Colors.blue,
  ),
  Wishlist(
    id: '3',
    title: 'Wishlist 3',
    description: 'Wishlist 3 description',
    createdAt: DateTime.now(),
    color: Colors.green,
  ),
  Wishlist(
    id: '4',
    title: 'Wishlist 4',
    description: 'Wishlist 4 description',
    createdAt: DateTime.now(),
    color: Colors.yellow,
  ),
  Wishlist(
    id: '5',
    title: 'Wishlist 5',
    description: 'Wishlist 5 description',
    createdAt: DateTime.now(),
    color: Colors.purple,
  ),
];

final List<WishlistItem> wishlistItems = [
  WishlistItem(
    id: '1',
    wishlistId: '1',
    title: 'Wishlist1',
    description: 'WishlistItem 1 description',
    imageUrl: 'https://via.placeholder.com/150',
    url: 'https://www.google.com',
  ),
  WishlistItem(
    id: '2',
    wishlistId: '1',
    title: 'Wishlist2',
    description: 'WishlistItem 2 description',
    imageUrl: 'https://via.placeholder.com/150',
    url: 'https://www.google.com',
  ),
  WishlistItem(
    id: '3',
    wishlistId: '2',
    title: 'Wishlist 3',
    description: 'WishlistItem 3 description',
    imageUrl: 'https://via.placeholder.com/150',
    url: 'https://www.google.com',
  ),
  WishlistItem(
    id: '4',
    wishlistId: '3',
    title: 'Wishlist 4',
    description: 'Wishlist 4 description',
    imageUrl: 'https://via.placeholder.com/150',
    url: 'https://www.google.com',
  ),
  WishlistItem(
    id: '5',
    wishlistId: '3',
    title: 'Wishlist 5',
    description: 'Wishlist 5 description',
    imageUrl: 'https://via.placeholder.com/150',
    url: 'https://www.google.com',
  ),
  WishlistItem(
    id: '6',
    wishlistId: '',
    title: 'Wishlist 6',
    description: 'Wishlist 6 description',
    imageUrl: 'https://via.placeholder.com/150',
    url: 'https://www.google.com',
  ),
  WishlistItem(
    id: '7',
    wishlistId: '3',
    title: 'Wishlist 7',
    description: 'Wishlist 7 description',
    imageUrl: 'https://via.placeholder.com/150',
    url: 'https://www.google.com',
  ),
  WishlistItem(
    id: '8',
    wishlistId: '4',
    title: 'Wishlist 8',
    description: 'Wishlist 8 description',
    imageUrl: 'https://via.placeholder.com/150',
    url: 'https://www.google.com',
  ),
  WishlistItem(
    id: '9',
    wishlistId: '1',
    title: 'Wishlist 9',
    description: 'Wishlist 8 description',
    imageUrl: 'https://via.placeholder.com/150',
    url: 'https://www.google.com',
  ),
  WishlistItem(
    id: '10',
    wishlistId: '1',
    title: 'Wishlist 10',
    description: 'Wishlist 8 description',
    imageUrl: 'https://via.placeholder.com/150',
    url: 'https://www.google.com',
  ),
];
