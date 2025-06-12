import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/wishlist_item.dart';
import '../../domain/models/wishlists.dart';
import '../../presentation/auth/authentication/auth_page.dart';
import '../../presentation/auth/profile/profile_page.dart';
import '../../presentation/home/tabs.dart';
import '../../presentation/item/item_page.dart';
import '../../presentation/wishlist/wishlist_page.dart';
import '../../presentation/home/widget/new_wishlist_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        // Auth Guard Wrapper
        AutoRoute(
          page: AuthWrapperRoute.page,
          path: '/',
          initial: true,
        ),

        // Main Routes
        AutoRoute(
          page: TabsRoute.page,
          path: '/home',
        ),
        AutoRoute(
          page: AuthRouteRoute.page,
          path: '/auth',
        ),
        AutoRoute(
          page: ProfileRouteRoute.page,
          path: '/profile',
        ),
        AutoRoute(
          page: WishlistRouteRoute.page,
          path: '/wishlist',
        ),
        AutoRoute(
          page: ItemRouteRoute.page,
          path: '/item',
        ),
        AutoRoute(
          page: NewWishlistRouteRoute.page,
          path: '/new-wishlist',
        ),
      ];
}

// Auth Wrapper to handle authentication state
@RoutePage()
class AuthWrapperPage extends StatelessWidget {
  const AuthWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        // Check if there is valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          // User is authenticated, redirect to home
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.router.navigate(const TabsRoute());
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          // User is not authenticated, redirect to auth
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.router.navigate(const AuthRouteRoute());
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

// Route Pages
@RoutePage()
class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) => const TabsScreen();
}

@RoutePage()
class AuthPageRoute extends StatelessWidget {
  const AuthPageRoute({super.key});

  @override
  Widget build(BuildContext context) => const AuthPage();
}

@RoutePage()
class ProfilePageRoute extends StatelessWidget {
  const ProfilePageRoute({super.key});

  @override
  Widget build(BuildContext context) => const ProfilePage();
}

@RoutePage()
class WishlistPageRoute extends StatelessWidget {
  const WishlistPageRoute({
    super.key,
    required this.wishlist,
    this.title,
    this.wishlistObject,
  });

  final List<WishlistItem> wishlist;
  final String? title;
  final Wishlist? wishlistObject;

  @override
  Widget build(BuildContext context) => WishlistPage(
        wishlist: wishlist,
        title: title,
        wishlistObject: wishlistObject,
      );
}

@RoutePage()
class ItemPageRoute extends StatelessWidget {
  const ItemPageRoute({
    super.key,
    required this.item,
  });

  final WishlistItem item;

  @override
  Widget build(BuildContext context) => ItemPage(item: item);
}

@RoutePage()
class NewWishlistPageRoute extends StatelessWidget {
  const NewWishlistPageRoute({
    super.key,
    this.existingWishlist,
  });

  final Wishlist? existingWishlist;

  @override
  Widget build(BuildContext context) => NewWishlistPage(
        existingWishlist: existingWishlist,
      );
}
