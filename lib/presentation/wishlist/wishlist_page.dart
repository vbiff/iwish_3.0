import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:auto_route/auto_route.dart';
import 'package:i_wish/presentation/wishlist/wish_item/wish_item_provider.dart';

import '../../core/navigation/app_router.dart';
import '../../domain/models/wishlist_item.dart';
import '../../domain/models/wishlists.dart';
import '../../domain/models/wishlist_color.dart';
import '../../core/utils/color_mapper.dart';
import '../home/items/items_provider.dart';
import '../home/wishlist_provider/wishlist_provider.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({
    super.key,
    required this.wishlist,
    this.title,
    this.wishlistObject,
  });

  final List<WishlistItem> wishlist;
  final String? title;
  final Wishlist? wishlistObject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemProvider = ref.read(wishItemProvider.notifier);
    final itemsAsync = ref.watch(itemsProvider);
    final wishlistsAsync = ref.watch(wishlistsProvider);

    // Get the current wishlist data from the provider for live updates
    Wishlist? currentWishlist;
    if (wishlistObject != null && wishlistsAsync.value != null) {
      try {
        currentWishlist = wishlistsAsync.value!.firstWhere(
          (w) => w.id == wishlistObject!.id,
        );
      } catch (e) {
        currentWishlist = wishlistObject;
      }
    } else {
      currentWishlist = wishlistObject;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.router.maybePop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      currentWishlist?.title ?? title ?? 'Wishlist',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (currentWishlist != null)
                    IconButton(
                      onPressed: () {
                        context.router.push(NewWishlistRouteRoute(
                          existingWishlist: currentWishlist!,
                        ));
                      },
                      icon: Icon(
                        Icons.edit_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),

            // Hero Section
            if (currentWishlist != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorMapper.toFlutterColor(currentWishlist.color),
                      ColorMapper.toFlutterColor(currentWishlist.color)
                          .withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorMapper.toFlutterColor(currentWishlist.color)
                          .withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentWishlist.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${itemsAsync.value?.length ?? 0} wishes',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Content
            Expanded(
              child: itemsAsync.when(
                data: (currentItems) {
                  if (currentItems.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: currentItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = currentItems[index];
                      return _buildWishItem(
                          context, ref, item, itemProvider, currentWishlist);
                    },
                  );
                },
                loading: () => _buildLoadingState(context),
                error: (error, stackTrace) =>
                    _buildErrorState(context, ref, error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishItem(BuildContext context, WidgetRef ref, WishlistItem item,
      dynamic itemProvider, Wishlist? currentWishlist) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              await itemProvider.deleteItem(item.id!);
              ref.invalidate(itemsProvider);
            },
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: BorderRadius.circular(16),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.router.push(ItemRouteRoute(item: item));
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .shadow
                    .withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: currentWishlist != null
                      ? ColorMapper.toFlutterColor(currentWishlist.color)
                          .withValues(alpha: 0.1)
                      : Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.card_giftcard_rounded,
                  color: currentWishlist != null
                      ? ColorMapper.toFlutterColor(currentWishlist.color)
                      : Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.description?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No wishes yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start adding items to your ${title?.toLowerCase() ?? 'wishlist'} to see them here',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add new wish functionality
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Your First Wish'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading your wishes...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(itemsProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
