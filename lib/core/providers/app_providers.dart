import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/auth_repository/auth_repository_impl.dart';
import '../../data/repository/auth_repository/profile_repository_impl.dart';
import '../../data/repository/wish_item_repository/wish_item_repository_impl.dart';
import '../../data/repository/wishlist_repository/wishlist_repository_impl.dart';
import '../../data/services/auth/auth_service.dart';
import '../../data/services/auth/profile_service.dart';
import '../../data/services/wish_item_service.dart';
import '../../data/services/wishlist_service.dart';
import '../../domain/models/app_state.dart';
import '../../domain/models/auth/user_profile.dart';
import '../../domain/models/wishlist_item.dart';
import '../../domain/models/wishlists.dart';
import '../../domain/repository/auth_repository/auth_repository.dart';
import '../../domain/repository/auth_repository/profile_repository.dart';
import '../../domain/repository/wish_item/wish_item_repository.dart';
import '../../domain/repository/wishlist_repository/wishlist_repository.dart';
import '../notifiers/app_notifier.dart';
import '../notifiers/auth_notifier.dart';
import '../notifiers/profile_notifier.dart';
import '../notifiers/items_notifier.dart';
import '../notifiers/wishlists_notifier.dart';

/// ========================================
/// SERVICE PROVIDERS (Data Layer)
/// ========================================

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Profile service provider
final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

/// Wishlist service provider
final wishlistServiceProvider = Provider<WishlistService>((ref) {
  return WishlistService();
});

/// Wish item service provider
final wishItemServiceProvider = Provider<WishItemService>((ref) {
  return WishItemService();
});

/// ========================================
/// REPOSITORY PROVIDERS (Domain Interface Implementation)
/// ========================================

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authService: ref.read(authServiceProvider),
  );
});

/// Profile repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    profileService: ref.read(profileServiceProvider),
  );
});

/// Wishlist repository provider
final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepositoryImpl(
    wishlistService: ref.read(wishlistServiceProvider),
  );
});

/// Wish item repository provider
final wishItemRepositoryProvider = Provider<WishItemRepository>((ref) {
  return WishItemRepositoryImpl(
    wishItemService: ref.read(wishItemServiceProvider),
  );
});

/// ========================================
/// STATE NOTIFIER PROVIDERS (Presentation Layer)
/// ========================================

/// Main application state notifier
final appNotifierProvider = NotifierProvider<AppNotifier, AppState>(
  AppNotifier.new,
);

/// Authentication state notifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);

/// User profile notifier
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>(
  (ref) => ProfileNotifier(ref.read(profileRepositoryProvider)),
);

/// Wishlists async notifier
final wishlistsNotifierProvider =
    AsyncNotifierProvider<WishlistsNotifier, List<Wishlist>>(
  WishlistsNotifier.new,
);

/// Items async notifier
final itemsNotifierProvider =
    AsyncNotifierProvider<ItemsNotifier, List<WishlistItem>>(
  ItemsNotifier.new,
);

/// ========================================
/// DERIVED PROVIDERS (Computed Values)
/// ========================================

/// Current user ID from auth state
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user?.id;
});

/// Filtered wishlists for current user
final userWishlistsProvider = Provider<List<Wishlist>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final wishlistsAsync = ref.watch(wishlistsNotifierProvider);

  return wishlistsAsync.when(
    data: (wishlists) => userId != null
        ? wishlists.where((w) => w.userId == userId).toList()
        : [],
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Items for a specific wishlist
final wishlistItemsProvider =
    Provider.family<List<WishlistItem>, String>((ref, wishlistId) {
  final itemsAsync = ref.watch(itemsNotifierProvider);

  return itemsAsync.when(
    data: (items) =>
        items.where((item) => item.wishlistId == wishlistId).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Wishlist statistics
final wishlistStatsProvider = Provider<WishlistStats>((ref) {
  final wishlists = ref.watch(userWishlistsProvider);
  final itemsAsync = ref.watch(itemsNotifierProvider);

  final items = itemsAsync.when(
    data: (items) => items,
    loading: () => <WishlistItem>[],
    error: (_, __) => <WishlistItem>[],
  );

  return WishlistStats(
    totalWishlists: wishlists.length,
    totalItems: items.length,
    wishlistsWithItems:
        wishlists.where((w) => items.any((i) => i.wishlistId == w.id)).length,
  );
});

/// ========================================
/// LEGACY PROVIDER COMPATIBILITY
/// ========================================

/// Legacy compatibility providers for existing code
/// These can be gradually migrated to the new structure

/// Legacy auth provider (compatibility)
final authProvider = authNotifierProvider;

/// Legacy profile provider (compatibility)
final profileProvider = profileNotifierProvider;

/// Legacy wishlists provider (compatibility)
final wishlistsProvider = wishlistsNotifierProvider;

/// Legacy items provider (compatibility)
final itemsProvider = itemsNotifierProvider;

/// ========================================
/// UTILITY CLASSES
/// ========================================

/// Statistics data class
class WishlistStats {
  const WishlistStats({
    required this.totalWishlists,
    required this.totalItems,
    required this.wishlistsWithItems,
  });

  final int totalWishlists;
  final int totalItems;
  final int wishlistsWithItems;

  int get emptyWishlists => totalWishlists - wishlistsWithItems;
  double get averageItemsPerWishlist =>
      totalWishlists > 0 ? totalItems / totalWishlists : 0.0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistStats &&
          runtimeType == other.runtimeType &&
          totalWishlists == other.totalWishlists &&
          totalItems == other.totalItems &&
          wishlistsWithItems == other.wishlistsWithItems;

  @override
  int get hashCode =>
      totalWishlists.hashCode ^
      totalItems.hashCode ^
      wishlistsWithItems.hashCode;

  @override
  String toString() {
    return 'WishlistStats(total: $totalWishlists, items: $totalItems, withItems: $wishlistsWithItems)';
  }
}
