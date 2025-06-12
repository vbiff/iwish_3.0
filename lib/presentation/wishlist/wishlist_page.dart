import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:auto_route/auto_route.dart';

import '../../core/navigation/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/async_value_widget.dart';
import '../../core/widgets/modern_card.dart';
import '../../core/widgets/modern_button.dart';
import '../../core/utils/color_mapper.dart';
import '../../domain/models/wishlist_item.dart';
import '../../domain/models/wishlists.dart';
import '../home/items/items_provider.dart';
import '../home/wishlist_provider/wishlist_provider.dart';
import 'wish_item/wish_item_provider.dart';

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
      floatingActionButton: currentWishlist != null
          ? ModernFloatingActionButton(
              onPressed: () =>
                  _showNewWishDialog(context, ref, currentWishlist!),
              icon: Icons.add_rounded,
              label: 'Add Wish',
              gradient: LinearGradient(
                colors: [
                  ColorMapper.toFlutterColor(currentWishlist.color),
                  ColorMapper.toFlutterColor(currentWishlist.color)
                      .withValues(alpha: 0.8),
                ],
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _ModernAppBar(
              title: currentWishlist?.title ?? title ?? 'Wishlist',
              onBack: () => context.router.maybePop(),
              onEdit: currentWishlist != null
                  ? () => context.router.push(NewWishlistRouteRoute(
                        existingWishlist: currentWishlist!,
                      ))
                  : null,
            ),

            // Hero Section
            if (currentWishlist != null)
              AsyncValueWidget(
                value: itemsAsync,
                data: (allItems) {
                  final filteredItemsCount = allItems
                      .where((item) => item.wishlistId == currentWishlist!.id)
                      .length;

                  return _HeroSection(
                    wishlist: currentWishlist!,
                    itemCount: filteredItemsCount,
                  );
                },
                loading: () => _HeroSection(
                  wishlist: currentWishlist!,
                  itemCount: null,
                ),
              ),

            const SizedBox(height: AppTheme.spacing2xl),

            // Content
            Expanded(
              child: ModernRefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(itemsProvider);
                },
                child: AsyncValueWidget(
                  value: itemsAsync,
                  data: (allItems) {
                    // Filter items based on wishlist
                    final List<WishlistItem> filteredItems;
                    if (currentWishlist != null) {
                      // Show only items for this specific wishlist
                      filteredItems = allItems
                          .where(
                              (item) => item.wishlistId == currentWishlist!.id)
                          .toList();
                    } else {
                      // Show all items (for "All Wishes" page)
                      filteredItems = allItems;
                    }

                    if (filteredItems.isEmpty) {
                      return ModernEmptyWidget(
                        title: 'No wishes yet',
                        message:
                            'Start adding items to your ${title?.toLowerCase() ?? 'wishlist'} to see them here',
                        icon: Icons.auto_awesome_outlined,
                        action: currentWishlist != null
                            ? () => _showNewWishDialog(
                                context, ref, currentWishlist!)
                            : null,
                        actionLabel: 'Add Your First Wish',
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing2xl),
                      itemCount: filteredItems.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppTheme.spacingMd),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _WishItem(
                          item: item,
                          wishlist: currentWishlist,
                          onDelete: () async {
                            await itemProvider.deleteItem(item.id!);
                            ref.invalidate(itemsProvider);
                          },
                          onTap: () =>
                              context.router.push(ItemRouteRoute(item: item)),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewWishDialog(
      BuildContext context, WidgetRef ref, Wishlist wishlist) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _NewWishDialog(wishlist: wishlist, ref: ref);
      },
    );
  }
}

class _ModernAppBar extends StatelessWidget {
  const _ModernAppBar({
    required this.title,
    required this.onBack,
    this.onEdit,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing2xl,
        AppTheme.spacing3xl,
        AppTheme.spacing2xl,
        AppTheme.spacing2xl,
      ),
      child: Row(
        children: [
          ModernIconButton(
            onPressed: onBack,
            icon: Icons.arrow_back_ios_new_rounded,
            variant: ModernButtonVariant.ghost,
          ),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          if (onEdit != null)
            ModernIconButton(
              onPressed: onEdit,
              icon: Icons.edit_rounded,
              variant: ModernButtonVariant.ghost,
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.wishlist,
    this.itemCount,
  });

  final Wishlist wishlist;
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing2xl),
      child: ModernGradientCard(
        gradient: LinearGradient(
          colors: [
            ColorMapper.toFlutterColor(wishlist.color),
            ColorMapper.toFlutterColor(wishlist.color).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wishlist.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    itemCount != null ? '$itemCount wishes' : '... wishes',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WishItem extends StatelessWidget {
  const _WishItem({
    required this.item,
    required this.onDelete,
    required this.onTap,
    this.wishlist,
  });

  final WishlistItem item;
  final Wishlist? wishlist;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
        ],
      ),
      child: ModernCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: wishlist != null
                    ? ColorMapper.toFlutterColor(wishlist!.color)
                        .withValues(alpha: 0.1)
                    : Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                Icons.card_giftcard_rounded,
                color: wishlist != null
                    ? ColorMapper.toFlutterColor(wishlist!.color)
                    : Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.description?.isNotEmpty == true) ...[
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      item.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
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
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _NewWishDialog extends StatefulWidget {
  const _NewWishDialog({required this.wishlist, required this.ref});

  final Wishlist wishlist;
  final WidgetRef ref;

  @override
  State<_NewWishDialog> createState() => _NewWishDialogState();
}

class _NewWishDialogState extends State<_NewWishDialog> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController urlController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    urlController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: ColorMapper.toFlutterColor(widget.wishlist.color)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: ColorMapper.toFlutterColor(widget.wishlist.color),
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Text(
              'Add New Wish',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add to "${widget.wishlist.title}"',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Title Field
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Wish Title *',
                hintText: 'What do you wish for?',
                prefixIcon: Icon(
                  Icons.star_outline_rounded,
                  color: ColorMapper.toFlutterColor(widget.wishlist.color),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Description Field
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Tell us more about this wish...',
                prefixIcon: Icon(
                  Icons.description_outlined,
                  color: ColorMapper.toFlutterColor(widget.wishlist.color),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // URL Field
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'Link (Optional)',
                hintText: 'https://example.com',
                prefixIcon: Icon(
                  Icons.link_rounded,
                  color: ColorMapper.toFlutterColor(widget.wishlist.color),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ModernButton.ghost(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ModernButton.primary(
          onPressed: () async {
            if (titleController.text.trim().isNotEmpty) {
              final newWish = WishlistItem(
                wishlistId: widget.wishlist.id,
                title: titleController.text.trim(),
                description: descriptionController.text.trim().isNotEmpty
                    ? descriptionController.text.trim()
                    : null,
                url: urlController.text.trim().isNotEmpty
                    ? urlController.text.trim()
                    : null,
              );

              try {
                await widget.ref
                    .read(wishItemProvider.notifier)
                    .createItem(newWish);
                widget.ref.invalidate(itemsProvider);

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Wish added to ${widget.wishlist.title}!'),
                      backgroundColor:
                          ColorMapper.toFlutterColor(widget.wishlist.color),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add wish: $e'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                  );
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Please enter a wish title'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
              );
            }
          },
          gradient: LinearGradient(
            colors: [
              ColorMapper.toFlutterColor(widget.wishlist.color),
              ColorMapper.toFlutterColor(widget.wishlist.color)
                  .withValues(alpha: 0.8),
            ],
          ),
          child: const Text('Add Wish'),
        ),
      ],
    );
  }
}
