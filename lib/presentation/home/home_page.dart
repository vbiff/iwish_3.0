import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import '../../core/navigation/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/async_value_widget.dart';
import '../../core/widgets/modern_card.dart';
import '../../core/widgets/modern_button.dart';
import '../../domain/models/wishlist_item.dart';
import '../../domain/models/wishlists.dart';
import 'items/items_provider.dart';
import 'wishlist_provider/wishlist_provider.dart';
import 'widget/wishlist_folder.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);
    final wishlistsAsync = ref.watch(wishlistsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: ModernRefreshIndicator(
          onRefresh: () async {
            ref.invalidate(itemsProvider);
            ref.invalidate(wishlistsProvider);
          },
          child: AsyncValueWidget(
            value: itemsAsync,
            data: (items) => CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.spacing2xl,
                      AppTheme.spacing3xl,
                      AppTheme.spacing2xl,
                      AppTheme.spacing2xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Wishes',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        Text(
                          'Organize and track your dreams',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Quick Stats Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing2xl),
                    child: ModernGradientCard(
                      gradient: AppTheme.primaryGradient,
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatsItem(
                              title: 'Total Wishes',
                              value: '${items.length}',
                              icon: Icons.star_rounded,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingLg),
                          AsyncValueWidget(
                            value: wishlistsAsync,
                            data: (wishlists) => Expanded(
                              child: _StatsItem(
                                title: 'Wishlists',
                                value: '${wishlists.length}',
                                icon: Icons.folder_rounded,
                              ),
                            ),
                            loading: () => Expanded(
                              child: _StatsItem(
                                title: 'Wishlists',
                                value: '...',
                                icon: Icons.folder_rounded,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                    child: SizedBox(height: AppTheme.spacing3xl)),

                // Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing2xl),
                    child: Text(
                      'Your Wishlists',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                    child: SizedBox(height: AppTheme.spacingLg)),

                // Wishlists Grid
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing2xl),
                    child: AsyncValueWidget(
                      value: wishlistsAsync,
                      data: (wishlists) =>
                          _buildWishlistGrid(context, ref, items, wishlists),
                      loading: () => _buildLoadingGrid(),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                    child: SizedBox(height: AppTheme.spacing3xl)),
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
      _AllWishesCard(items: items),

      // Individual Wishlists
      ...wishlists.map((wishlist) => GestureDetector(
            onLongPress: () =>
                _showDeleteWishlistDialog(context, ref, wishlist),
            child: WishlistFolder(
              wishlist: wishlist,
              id: wishlist.id,
            ),
          )),

      // Add New Wishlist Card
      _AddWishlistCard(),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      crossAxisSpacing: AppTheme.spacingLg,
      mainAxisSpacing: AppTheme.spacingLg,
      children: gridItems,
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      crossAxisSpacing: AppTheme.spacingLg,
      mainAxisSpacing: AppTheme.spacingLg,
      children: List.generate(4, (index) => _LoadingCard()),
    );
  }

  void _showDeleteWishlistDialog(
      BuildContext context, WidgetRef ref, Wishlist wishlist) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Text(
                  'Delete Wishlist',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete "${wishlist.title}"?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              ModernCard(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                color: Theme.of(context)
                    .colorScheme
                    .errorContainer
                    .withValues(alpha: 0.3),
                elevation: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: Text(
                        'This action cannot be undone. All wishes in this list will also be deleted.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ModernButton.ghost(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ModernButton.destructive(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ref
                      .read(wishlistsProvider.notifier)
                      .deleteWishlist(wishlist.id);
                  ref.invalidate(itemsProvider);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${wishlist.title} deleted successfully'),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete wishlist: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                        ),
                      ),
                    );
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _StatsItem extends StatelessWidget {
  const _StatsItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withValues(alpha: 0.9),
              size: 20,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingXs),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

class _AllWishesCard extends StatelessWidget {
  const _AllWishesCard({required this.items});

  final List<WishlistItem> items;

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: () => context.router.push(
        WishlistRouteRoute(
          wishlist: items,
          title: 'All my wishes',
        ),
      ),
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.tertiary,
          Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Spacer(),
          Text(
            'All Wishes',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            '${items.length} items',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
          ),
        ],
      ),
    );
  }
}

class _AddWishlistCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: () => context.router.push(NewWishlistRouteRoute()),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        width: 2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            ),
            child: Icon(
              Icons.add_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            'New Wishlist',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Container(
            width: 80,
            height: 12,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
          ),
        ],
      ),
    );
  }
}
