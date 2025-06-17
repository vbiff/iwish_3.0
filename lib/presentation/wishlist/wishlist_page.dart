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
import '../home/widget/name_screen.dart';
import 'wish_item/wish_item_provider.dart';

class WishlistPage extends ConsumerStatefulWidget {
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
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  List<WishlistItem> _localItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final itemsAsync = ref.read(itemsProvider);
    if (itemsAsync.hasValue) {
      _localItems = List.from(itemsAsync.value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = ref.read(wishItemProvider.notifier);
    final itemsAsync = ref.watch(itemsProvider);
    final wishlistsAsync = ref.watch(wishlistsProvider);

    // Update local items when the async data changes
    if (itemsAsync.hasValue && _localItems.isEmpty) {
      _localItems = List.from(itemsAsync.value!);
    }

    // Get the current wishlist data from the provider for live updates
    Wishlist? currentWishlist;
    if (widget.wishlistObject != null && wishlistsAsync.value != null) {
      try {
        currentWishlist = wishlistsAsync.value!.firstWhere(
          (w) => w.id == widget.wishlistObject!.id,
        );
      } catch (e) {
        currentWishlist = widget.wishlistObject;
      }
    } else {
      currentWishlist = widget.wishlistObject;
    }

    // Filter items based on current wishlist
    final List<WishlistItem> filteredItems;
    if (currentWishlist != null) {
      // Use itemsAsync.value instead of _localItems for live updates
      if (itemsAsync.hasValue) {
        // If we have local items during reordering, use those instead
        if (_localItems.isNotEmpty) {
          filteredItems = _localItems
              .where((item) => item.wishlistId == currentWishlist!.id)
              .toList();
        } else {
          filteredItems = itemsAsync.value!
              .where((item) => item.wishlistId == currentWishlist!.id)
              .toList();
          // Keep local items in sync when not reordering
          _localItems = List.from(itemsAsync.value!);
        }
      } else {
        filteredItems = [];
      }
    } else {
      filteredItems = _localItems;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: currentWishlist != null
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorMapper.toFlutterColor(currentWishlist.color),
                    ColorMapper.toFlutterColor(currentWishlist.color)
                        .withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorMapper.toFlutterColor(currentWishlist.color)
                        .withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () =>
                    _showNewWishDialog(context, ref, currentWishlist!),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                child: const Icon(Icons.auto_awesome, size: 24),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _ModernAppBar(
              title: currentWishlist?.title ?? widget.title ?? 'Wishlist',
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
                  // Clear local items to force refresh from provider
                  setState(() {
                    _localItems.clear();
                  });
                  ref.invalidate(itemsProvider);
                },
                child: AsyncValueWidget(
                  value: itemsAsync,
                  data: (allItems) {
                    if (filteredItems.isEmpty) {
                      return ModernEmptyWidget(
                        title: 'No wishes yet',
                        message:
                            'Start adding items to your ${widget.title?.toLowerCase() ?? 'wishlist'} to see them here',
                        icon: Icons.auto_awesome_outlined,
                      );
                    }

                    return ReorderableListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing2xl),
                      itemCount: filteredItems.length,
                      buildDefaultDragHandles: false,
                      onReorder: (int oldIndex, int newIndex) async {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = filteredItems.removeAt(oldIndex);
                          filteredItems.insert(newIndex, item);

                          // Update local items list to maintain order during reordering
                          if (currentWishlist != null) {
                            final allItemsOldIndex =
                                _localItems.indexWhere((i) => i.id == item.id);
                            if (allItemsOldIndex != -1) {
                              _localItems.removeAt(allItemsOldIndex);
                              // Find the correct position in _localItems
                              final targetItem = filteredItems[
                                  newIndex > 0 ? newIndex - 1 : 0];
                              final targetIndex = _localItems
                                  .indexWhere((i) => i.id == targetItem.id);
                              _localItems.insert(targetIndex + 1, item);
                            }
                          }
                        });

                        // Update database in the background
                        Future.microtask(() async {
                          for (var i = 0; i < filteredItems.length; i++) {
                            final currentItem = filteredItems[i];
                            if (currentItem.id != null) {
                              await itemProvider.updateItem(currentItem);
                            }
                          }
                          // Don't invalidate provider here to prevent jumps
                        });
                      },
                      proxyDecorator: (child, index, animation) {
                        return AnimatedBuilder(
                          animation: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                          builder: (BuildContext context, Widget? child) {
                            final scale = 1.0 + (0.02 * animation.value);
                            final elevation = 6.0 * animation.value;

                            return Transform.scale(
                              scale: scale,
                              child: Material(
                                elevation: elevation,
                                color: Colors.transparent,
                                shadowColor: Theme.of(context)
                                    .colorScheme
                                    .shadow
                                    .withValues(alpha: 0.15),
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusMd),
                                child: child,
                              ),
                            );
                          },
                          child: child,
                        );
                      },
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ReorderableDelayedDragStartListener(
                          key: ValueKey(item.id),
                          index: index,
                          child: Column(
                            children: [
                              _WishItem(
                                item: item,
                                wishlist: currentWishlist,
                                onDelete: () async {
                                  // Remove from local state first
                                  setState(() {
                                    _localItems
                                        .removeWhere((i) => i.id == item.id);
                                  });

                                  // Then update database
                                  await itemProvider.deleteItem(item.id!);
                                  ref.invalidate(itemsProvider);
                                },
                                onTap: () => context.router
                                    .push(ItemRouteRoute(item: item)),
                              ),
                              if (index < filteredItems.length - 1)
                                Divider(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                                  height: 1,
                                ),
                            ],
                          ),
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
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return NameScreen(
          wishlist: wishlist,
          onPressed: () {
            // Just invalidate the provider and close the modal
            ref.invalidate(itemsProvider);
            context.router.maybePop();
          },
        );
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

class _WishItem extends ConsumerWidget {
  const _WishItem({
    required this.item,
    required this.wishlist,
    required this.onDelete,
    required this.onTap,
  });

  final WishlistItem item;
  final Wishlist? wishlist;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistsAsync = ref.watch(wishlistsProvider);

    // Get the color of the folder where this item is stored
    Color itemColor = Theme.of(context).colorScheme.primary;
    if (wishlistsAsync.hasValue && item.wishlistId != null) {
      final itemWishlist = wishlistsAsync.value!.firstWhere(
        (w) => w.id == item.wishlistId,
        orElse: () =>
            wishlist ??
            Wishlist(
              id: '',
              userId: '',
              title: '',
              createdAt: DateTime.now(),
            ),
      );
      itemColor = ColorMapper.toFlutterColor(itemWishlist.color);
    }

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
            icon: Icons.delete_rounded,
            label: 'Delete',
          ),
        ],
      ),
      child: ModernCard(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: itemColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Icon(
                      Icons.card_giftcard_rounded,
                      size: 18,
                      color: itemColor,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              _showMoveToFolderDialog(context, ref, item),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: itemColor.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSm),
                            ),
                            child: Icon(
                              Icons.edit_rounded,
                              size: 16,
                              color: itemColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (item.description != null && item.description!.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  item.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showMoveToFolderDialog(
      BuildContext context, WidgetRef ref, WishlistItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _MoveToFolderDialog(item: item);
      },
    );
  }
}

class _MoveToFolderDialog extends ConsumerWidget {
  const _MoveToFolderDialog({
    required this.item,
  });

  final WishlistItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistsAsync = ref.watch(wishlistsProvider);
    final itemProvider = ref.read(wishItemProvider.notifier);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing2xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Move to Folder',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Choose a folder to move this item to:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
            ),
            const SizedBox(height: AppTheme.spacingXl),
            AsyncValueWidget(
              value: wishlistsAsync,
              data: (wishlists) => Column(
                mainAxisSize: MainAxisSize.min,
                children: wishlists.map((wishlist) {
                  final isSelected = wishlist.id == item.wishlistId;
                  return ModernCard(
                    margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                    onTap: isSelected
                        ? null
                        : () async {
                            final updatedItem = item.copyWith(
                              wishlistId: wishlist.id,
                            );
                            await itemProvider.updateItem(updatedItem);
                            ref.invalidate(itemsProvider);
                            if (context.mounted) {
                              context.router.maybePop();
                            }
                          },
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: ColorMapper.toFlutterColor(wishlist.color)
                                .withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                          ),
                          child: Icon(
                            Icons.folder_rounded,
                            size: 20,
                            color: ColorMapper.toFlutterColor(wishlist.color),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingLg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                wishlist.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: ColorMapper.toFlutterColor(wishlist.color),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),
            ModernButton.ghost(
              onPressed: () => context.router.maybePop(),
              child: const Text('Cancel'),
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
          onPressed: () => Navigator.of(context).maybePop(),
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
                  Navigator.of(context).maybePop();
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
