import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/data/repository/wish_item_repository/wish_item_repository_impl.dart';

import 'package:i_wish/domain/repository/wish_item/wish_item_repository.dart';

import '../../../data/services/wish_item_service.dart';
import '../../../domain/models/wishlist_item.dart';
import 'wish_item_notifier.dart';

final wishItemServiceProvider = Provider<WishItemService>((ref) {
  return WishItemService();
});

final itemRepositoryProvider = Provider<WishItemRepository>((ref) {
  return WishItemRepositoryImpl(
    wishItemService: ref.read(wishItemServiceProvider),
  );
});

final wishItemProvider =
    StateNotifierProvider<WishItemNotifier, WishlistItem>((ref) {
  final itemRepoProvider = ref.read(itemRepositoryProvider);
  return WishItemNotifier(itemRepoProvider);
});
