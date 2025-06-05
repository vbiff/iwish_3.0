import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/data/repository/wish_item_repository/wish_item_repository_impl.dart';
import 'package:i_wish/domain/repository/wish_item/wish_item_repository.dart';

import '../../../data/services/wish_item_service.dart';
import '../../../domain/models/wishlist_item.dart';
import 'items_notifier.dart';

final wishItemServiceProvider = Provider<WishItemService>((ref) {
  return WishItemService();
});

final wishItemProviderFromSupabase = Provider<WishItemRepository>((ref) {
  return WishItemRepositoryImpl(
    wishItemService: ref.read(wishItemServiceProvider),
  );
});

final itemListProvider =
    StateNotifierProvider<ItemFromSupabaseNotifier, List<WishlistItem>>((ref) {
  final wishItemRepo = ref.read(wishItemProviderFromSupabase);
  return ItemFromSupabaseNotifier(wishItemRepo);
});
