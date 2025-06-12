import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/wish_item_repository/wish_item_repository_impl.dart';
import '../../../data/services/wish_item_service.dart';
import '../../../domain/models/wishlist_item.dart';
import '../../../domain/repository/wish_item/wish_item_repository.dart';
import 'items_notifier.dart';

final wishItemServiceProvider = Provider<WishItemService>((ref) {
  return WishItemService();
});

final wishItemRepositoryProvider = Provider<WishItemRepository>((ref) {
  return WishItemRepositoryImpl(
    wishItemService: ref.read(wishItemServiceProvider),
  );
});

final itemsProvider =
    AsyncNotifierProvider<ItemsAsyncNotifier, List<WishlistItem>>(
  ItemsAsyncNotifier.new,
);
