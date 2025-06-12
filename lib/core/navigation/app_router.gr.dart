// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AuthRouteRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthPageRoute(),
      );
    },
    AuthWrapperRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthWrapperPage(),
      );
    },
    ItemRouteRoute.name: (routeData) {
      final args = routeData.argsAs<ItemRouteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ItemPageRoute(
          key: args.key,
          item: args.item,
        ),
      );
    },
    NewWishlistRouteRoute.name: (routeData) {
      final args = routeData.argsAs<NewWishlistRouteRouteArgs>(
          orElse: () => const NewWishlistRouteRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NewWishlistPageRoute(
          key: args.key,
          existingWishlist: args.existingWishlist,
        ),
      );
    },
    ProfileRouteRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePageRoute(),
      );
    },
    TabsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TabsPage(),
      );
    },
    WishlistRouteRoute.name: (routeData) {
      final args = routeData.argsAs<WishlistRouteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WishlistPageRoute(
          key: args.key,
          wishlist: args.wishlist,
          title: args.title,
          wishlistObject: args.wishlistObject,
        ),
      );
    },
  };
}

/// generated route for
/// [AuthPageRoute]
class AuthRouteRoute extends PageRouteInfo<void> {
  const AuthRouteRoute({List<PageRouteInfo>? children})
      : super(
          AuthRouteRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRouteRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AuthWrapperPage]
class AuthWrapperRoute extends PageRouteInfo<void> {
  const AuthWrapperRoute({List<PageRouteInfo>? children})
      : super(
          AuthWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthWrapperRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ItemPageRoute]
class ItemRouteRoute extends PageRouteInfo<ItemRouteRouteArgs> {
  ItemRouteRoute({
    Key? key,
    required WishlistItem item,
    List<PageRouteInfo>? children,
  }) : super(
          ItemRouteRoute.name,
          args: ItemRouteRouteArgs(
            key: key,
            item: item,
          ),
          initialChildren: children,
        );

  static const String name = 'ItemRouteRoute';

  static const PageInfo<ItemRouteRouteArgs> page =
      PageInfo<ItemRouteRouteArgs>(name);
}

class ItemRouteRouteArgs {
  const ItemRouteRouteArgs({
    this.key,
    required this.item,
  });

  final Key? key;

  final WishlistItem item;

  @override
  String toString() {
    return 'ItemRouteRouteArgs{key: $key, item: $item}';
  }
}

/// generated route for
/// [NewWishlistPageRoute]
class NewWishlistRouteRoute extends PageRouteInfo<NewWishlistRouteRouteArgs> {
  NewWishlistRouteRoute({
    Key? key,
    Wishlist? existingWishlist,
    List<PageRouteInfo>? children,
  }) : super(
          NewWishlistRouteRoute.name,
          args: NewWishlistRouteRouteArgs(
            key: key,
            existingWishlist: existingWishlist,
          ),
          initialChildren: children,
        );

  static const String name = 'NewWishlistRouteRoute';

  static const PageInfo<NewWishlistRouteRouteArgs> page =
      PageInfo<NewWishlistRouteRouteArgs>(name);
}

class NewWishlistRouteRouteArgs {
  const NewWishlistRouteRouteArgs({
    this.key,
    this.existingWishlist,
  });

  final Key? key;

  final Wishlist? existingWishlist;

  @override
  String toString() {
    return 'NewWishlistRouteRouteArgs{key: $key, existingWishlist: $existingWishlist}';
  }
}

/// generated route for
/// [ProfilePageRoute]
class ProfileRouteRoute extends PageRouteInfo<void> {
  const ProfileRouteRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRouteRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRouteRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TabsPage]
class TabsRoute extends PageRouteInfo<void> {
  const TabsRoute({List<PageRouteInfo>? children})
      : super(
          TabsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TabsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WishlistPageRoute]
class WishlistRouteRoute extends PageRouteInfo<WishlistRouteRouteArgs> {
  WishlistRouteRoute({
    Key? key,
    required List<WishlistItem> wishlist,
    String? title,
    Wishlist? wishlistObject,
    List<PageRouteInfo>? children,
  }) : super(
          WishlistRouteRoute.name,
          args: WishlistRouteRouteArgs(
            key: key,
            wishlist: wishlist,
            title: title,
            wishlistObject: wishlistObject,
          ),
          initialChildren: children,
        );

  static const String name = 'WishlistRouteRoute';

  static const PageInfo<WishlistRouteRouteArgs> page =
      PageInfo<WishlistRouteRouteArgs>(name);
}

class WishlistRouteRouteArgs {
  const WishlistRouteRouteArgs({
    this.key,
    required this.wishlist,
    this.title,
    this.wishlistObject,
  });

  final Key? key;

  final List<WishlistItem> wishlist;

  final String? title;

  final Wishlist? wishlistObject;

  @override
  String toString() {
    return 'WishlistRouteRouteArgs{key: $key, wishlist: $wishlist, title: $title, wishlistObject: $wishlistObject}';
  }
}
