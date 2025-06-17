import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import '../../core/navigation/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/async_value_widget.dart';
import '../../core/widgets/figma_card.dart';
import '../../core/widgets/figma_button.dart';
import '../../core/utils/color_mapper.dart';
import '../../domain/models/wishlist_item.dart';
import '../../domain/models/wishlists.dart';
import 'items/items_provider.dart';
import 'wishlist_provider/wishlist_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);
    final wishlistsAsync = ref.watch(wishlistsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(itemsProvider);
            ref.invalidate(wishlistsProvider);
          },
          color: AppTheme.primaryYellow,
          backgroundColor: AppTheme.backgroundWhite,
          child: AsyncValueWidget(
            value: itemsAsync,
            data: (items) => CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.spacing24,
                      AppTheme.spacing32,
                      AppTheme.spacing24,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Title
                        const Text(
                          'My Wishes',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryBlack,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing8),

                        // Subtitle
                        const Text(
                          'Track your dreams and make them come true',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.secondaryGray,
                            letterSpacing: -0.1,
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacing32),

                        // Quick Stats Section
                        AsyncValueWidget(
                          value: wishlistsAsync,
                          data: (wishlists) => Row(
                            children: [
                              Expanded(
                                child: FigmaStatsCard(
                                  title: 'Total Wishes',
                                  value: '${items.length}',
                                  icon: Icons.favorite_rounded,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacing16),
                              Expanded(
                                child: FigmaStatsCard(
                                  title: 'Wishlists',
                                  value: '${wishlists.length}',
                                  icon: Icons.folder_rounded,
                                ),
                              ),
                            ],
                          ),
                          loading: () => Row(
                            children: [
                              Expanded(
                                child: FigmaStatsCard(
                                  title: 'Total Wishes',
                                  value: '${items.length}',
                                  icon: Icons.favorite_rounded,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacing16),
                              const Expanded(
                                child: FigmaStatsCard(
                                  title: 'Wishlists',
                                  value: '...',
                                  icon: Icons.folder_rounded,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing48),
                ),

                // Wishlists Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Wishlists',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlack,
                            letterSpacing: -0.4,
                          ),
                        ),
                        FigmaButton(
                          text: 'View All',
                          variant: FigmaButtonVariant.ghost,
                          size: FigmaButtonSize.small,
                          onPressed: () {
                            // Navigate to all wishlists
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing20),
                ),

                // Wishlists Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing24),
                  sliver: AsyncValueWidget(
                    value: wishlistsAsync,
                    data: (wishlists) =>
                        _buildWishlistGrid(context, ref, items, wishlists),
                    loading: () => _buildLoadingGrid(),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing48),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistGrid(BuildContext context, WidgetRef ref,
      List<WishlistItem> items, List<Wishlist> wishlists) {
    final List<Widget> gridItems = [
      // All Wishes Card
      FigmaWishCard(
        title: 'All Items',
        count: items.length,
        color: AppTheme.primaryYellow,
        onTap: () {
          context.router.push(
            WishlistRouteRoute(
              wishlist: items,
              title: 'All my wishes',
            ),
          );
        },
      ),

      // Individual Wishlists
      ...wishlists.take(5).map((wishlist) {
        final wishlistItems =
            items.where((item) => item.wishlistId == wishlist.id).length;
        return FigmaWishCard(
          title: wishlist.title,
          count: wishlistItems,
          color: ColorMapper.toFlutterColor(wishlist.color),
          onTap: () {
            context.router.push(WishlistRouteRoute(
              wishlistObject: wishlist,
              wishlist: items
                  .where((item) => item.wishlistId == wishlist.id)
                  .toList(),
            ));
          },
        );
      }),

      // Add New Wishlist Card
      FigmaAddCard(
        title: 'New Wishlist',
        subtitle: 'Create a new collection',
        onTap: () => context.router.push(NewWishlistRouteRoute()),
      ),
    ];

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: AppTheme.spacing16,
        mainAxisSpacing: AppTheme.spacing16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => gridItems[index],
        childCount: gridItems.length,
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: AppTheme.spacing16,
        mainAxisSpacing: AppTheme.spacing16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => const _LoadingCard(),
        childCount: 6,
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return FigmaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Loading color indicator
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
            ),
          ),

          const Spacer(),

          // Loading title
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(AppTheme.radius4),
            ),
          ),

          const SizedBox(height: AppTheme.spacing8),

          // Loading count
          Container(
            width: 60,
            height: 12,
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(AppTheme.radius4),
            ),
          ),
        ],
      ),
    );
  }
}
