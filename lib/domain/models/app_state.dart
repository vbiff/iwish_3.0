import 'wishlist_item.dart';
import 'wishlists.dart';

/// Application state model that encapsulates all core app data
class AppState {
  const AppState({
    this.wishlists = const [],
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.selectedWishlistId,
  });

  final List<Wishlist> wishlists;
  final List<WishlistItem> items;
  final bool isLoading;
  final String? error;
  final String? selectedWishlistId;

  AppState copyWith({
    List<Wishlist>? wishlists,
    List<WishlistItem>? items,
    bool? isLoading,
    String? Function()? error,
    String? Function()? selectedWishlistId,
  }) {
    return AppState(
      wishlists: wishlists ?? this.wishlists,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
      selectedWishlistId: selectedWishlistId != null
          ? selectedWishlistId()
          : this.selectedWishlistId,
    );
  }

  // Business logic methods
  Wishlist? get selectedWishlist => selectedWishlistId != null
      ? wishlists.where((w) => w.id == selectedWishlistId).firstOrNull
      : null;

  List<WishlistItem> getItemsForWishlist(String wishlistId) {
    return items.where((item) => item.wishlistId == wishlistId).toList();
  }

  int get totalItems => items.length;

  int get totalWishlists => wishlists.length;

  bool get hasData => wishlists.isNotEmpty;

  bool get hasError => error != null;

  // Factory constructors for common states
  factory AppState.loading() {
    return const AppState(isLoading: true);
  }

  factory AppState.error(String error) {
    return AppState(error: error);
  }

  factory AppState.initial() {
    return const AppState();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          _listEquals(wishlists, other.wishlists) &&
          _listEquals(items, other.items) &&
          isLoading == other.isLoading &&
          error == other.error &&
          selectedWishlistId == other.selectedWishlistId;

  @override
  int get hashCode =>
      wishlists.hashCode ^
      items.hashCode ^
      isLoading.hashCode ^
      error.hashCode ^
      selectedWishlistId.hashCode;

  @override
  String toString() {
    return 'AppState(wishlists: ${wishlists.length}, items: ${items.length}, isLoading: $isLoading, hasError: $hasError)';
  }
}

// Helper function for list comparison
bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Extension to add list operations to AppState
extension AppStateOperations on AppState {
  /// Add a new wishlist to the state
  AppState addWishlist(Wishlist wishlist) {
    return copyWith(
      wishlists: [...wishlists, wishlist],
    );
  }

  /// Update an existing wishlist
  AppState updateWishlist(Wishlist updatedWishlist) {
    final updatedList = wishlists.map((w) {
      return w.id == updatedWishlist.id ? updatedWishlist : w;
    }).toList();

    return copyWith(wishlists: updatedList);
  }

  /// Remove a wishlist and its items
  AppState removeWishlist(String wishlistId) {
    final filteredWishlists =
        wishlists.where((w) => w.id != wishlistId).toList();
    final filteredItems =
        items.where((i) => i.wishlistId != wishlistId).toList();

    return copyWith(
      wishlists: filteredWishlists,
      items: filteredItems,
      selectedWishlistId: selectedWishlistId == wishlistId ? () => null : null,
    );
  }

  /// Add a new item to the state
  AppState addItem(WishlistItem item) {
    return copyWith(
      items: [...items, item],
    );
  }

  /// Update an existing item
  AppState updateItem(WishlistItem updatedItem) {
    final updatedList = items.map((i) {
      return i.id == updatedItem.id ? updatedItem : i;
    }).toList();

    return copyWith(items: updatedList);
  }

  /// Remove an item
  AppState removeItem(String itemId) {
    final filteredItems = items.where((i) => i.id != itemId).toList();
    return copyWith(items: filteredItems);
  }

  /// Select a wishlist
  AppState selectWishlist(String? wishlistId) {
    return copyWith(selectedWishlistId: () => wishlistId);
  }

  /// Clear error state
  AppState clearError() {
    return copyWith(error: () => null);
  }

  /// Set loading state
  AppState setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }
}
