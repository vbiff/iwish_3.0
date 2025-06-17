import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/modern_card.dart';
import '../../core/widgets/modern_button.dart';
import '../../core/utils/color_mapper.dart';
import '../../domain/models/wishlist_item.dart';
import '../home/wishlist_provider/wishlist_provider.dart';
import '../home/items/items_provider.dart';
import '../wishlist/wish_item/wish_item_provider.dart';

class ItemPage extends ConsumerStatefulWidget {
  const ItemPage({
    super.key,
    required this.item,
  });

  final WishlistItem item;

  @override
  ConsumerState<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends ConsumerState<ItemPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late WishlistItem _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showEditDialog(BuildContext context, Color itemColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _EditItemDialog(
        item: _currentItem,
        itemColor: itemColor,
        onItemUpdated: (updatedItem) {
          setState(() {
            _currentItem = updatedItem;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistsAsync = ref.watch(wishlistsProvider);

    // Get the color of the wishlist this item belongs to
    Color itemColor = Theme.of(context).colorScheme.primary;
    if (wishlistsAsync.hasValue && _currentItem.wishlistId != null) {
      final itemWishlist = wishlistsAsync.value!.firstWhere(
        (w) => w.id == _currentItem.wishlistId,
        orElse: () => wishlistsAsync.value!.first,
      );
      itemColor = ColorMapper.toFlutterColor(itemWishlist.color);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: itemColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          itemColor,
                          itemColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background Pattern
                        Positioned.fill(
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.1),
                                    Colors.white.withValues(alpha: 0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  backgroundBlendMode: BlendMode.dstIn,
                                ),
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 150,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Title Content
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(AppTheme.spacing2xl),
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Wish Details',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Colors.white
                                                .withValues(alpha: 0.9),
                                          ),
                                    ),
                                    const SizedBox(height: AppTheme.spacingSm),
                                    Text(
                                      _currentItem.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  onPressed: () => context.router.maybePop(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    color: Colors.white,
                    onPressed: () => _showEditDialog(context, itemColor),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    color: Colors.white,
                    onPressed: () {
                      Share.share(
                        'Check out my wish: ${_currentItem.title}${_currentItem.url != null ? '\n${_currentItem.url}' : ''}',
                      );
                    },
                  ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing2xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Price and Description Card
                          ModernCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(
                                          AppTheme.spacingMd),
                                      decoration: BoxDecoration(
                                        color: itemColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(
                                            AppTheme.radiusSm),
                                      ),
                                      child: Icon(
                                        Icons.card_giftcard_rounded,
                                        color: itemColor,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.spacingLg),
                                    if (_currentItem.price != null &&
                                        _currentItem.price!.isNotEmpty)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Price',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                            ),
                                            const SizedBox(
                                                height: AppTheme.spacingXs),
                                            Text(
                                              _currentItem.price!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    color: itemColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                if (_currentItem.description != null &&
                                    _currentItem.description!.isNotEmpty) ...[
                                  const SizedBox(height: AppTheme.spacingLg),
                                  Text(
                                    'Description',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: AppTheme.spacingSm),
                                  Text(
                                    _currentItem.description!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: AppTheme.spacingXl),

                          // Image Section with Hero Animation
                          if (_currentItem.imageUrl != null &&
                              _currentItem.imageUrl!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Image',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: AppTheme.spacingLg),
                                Hero(
                                  tag: 'item_image_${_currentItem.id}',
                                  child: ModernCard(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: InteractiveViewer(
                                            child: Image.network(
                                              _currentItem.imageUrl!,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          AppTheme.radiusMd),
                                      child: Image.network(
                                        _currentItem.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          padding: const EdgeInsets.all(
                                              AppTheme.spacingXl),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHighest,
                                            borderRadius: BorderRadius.circular(
                                                AppTheme.radiusMd),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.broken_image_rounded,
                                                size: 48,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                              const SizedBox(
                                                  height: AppTheme.spacingMd),
                                              Text(
                                                'Failed to load image',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacingXl),
                              ],
                            ),

                          // Link Section with Animation
                          if (_currentItem.url != null &&
                              _currentItem.url!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Link',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: AppTheme.spacingLg),
                                ModernCard(
                                  onTap: () => _launchURL(
                                      context, _currentItem.url!, itemColor),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(
                                                AppTheme.spacingMd),
                                            decoration: BoxDecoration(
                                              color: itemColor.withValues(
                                                  alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppTheme.radiusSm),
                                            ),
                                            child: Icon(
                                              Icons.link_rounded,
                                              color: itemColor,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(
                                              width: AppTheme.spacingLg),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'View Product',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                const SizedBox(
                                                    height: AppTheme.spacingXs),
                                                Text(
                                                  _currentItem.url!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                              width: AppTheme.spacingLg),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      Positioned.fill(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                                AppTheme.radiusMd),
                                            onTap: () => _launchURL(context,
                                                _currentItem.url!, itemColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: AppTheme.spacing3xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(
      BuildContext context, String urlString, Color itemColor) async {
    try {
      if (!urlString.startsWith('http://') &&
          !urlString.startsWith('https://')) {
        urlString = 'https://$urlString';
      }
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode
              .externalApplication, // Forces opening in external browser
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Could not open this link'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid URL: $urlString'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
        );
      }
    }
  }
}

class _EditItemDialog extends ConsumerStatefulWidget {
  const _EditItemDialog({
    required this.item,
    required this.itemColor,
    required this.onItemUpdated,
  });

  final WishlistItem item;
  final Color itemColor;
  final Function(WishlistItem) onItemUpdated;

  @override
  ConsumerState<_EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends ConsumerState<_EditItemDialog> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController urlController;
  late final TextEditingController imageUrlController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    descriptionController =
        TextEditingController(text: widget.item.description ?? '');
    priceController = TextEditingController(text: widget.item.price ?? '');
    urlController = TextEditingController(text: widget.item.url ?? '');
    imageUrlController =
        TextEditingController(text: widget.item.imageUrl ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    urlController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing2xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingSm),
                    decoration: BoxDecoration(
                      color: widget.itemColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: widget.itemColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: Text(
                      'Edit Wish',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingXl),

              // Title Field
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  hintText: 'What do you wish for?',
                  prefixIcon: Icon(
                    Icons.star_outline_rounded,
                    color: widget.itemColor,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Price Field
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'How much does it cost?',
                  prefixIcon: Icon(
                    Icons.attach_money_rounded,
                    color: widget.itemColor,
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
                    color: widget.itemColor,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // URL Field
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'Link',
                  hintText: 'https://example.com',
                  prefixIcon: Icon(
                    Icons.link_rounded,
                    color: widget.itemColor,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Image URL Field
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'https://example.com/image.jpg',
                  prefixIcon: Icon(
                    Icons.image_outlined,
                    color: widget.itemColor,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing2xl),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ModernButton.ghost(
                    onPressed:
                        _isLoading ? null : () => context.router.maybePop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  ModernButton.primary(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (titleController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Please enter a title'),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppTheme.radiusMd),
                                  ),
                                ),
                              );
                              return;
                            }

                            setState(() => _isLoading = true);

                            try {
                              final updatedItem = widget.item.copyWith(
                                title: titleController.text.trim(),
                                description: () =>
                                    descriptionController.text.trim().isNotEmpty
                                        ? descriptionController.text.trim()
                                        : null,
                                price: () =>
                                    priceController.text.trim().isNotEmpty
                                        ? priceController.text.trim()
                                        : null,
                                url: () => urlController.text.trim().isNotEmpty
                                    ? urlController.text.trim()
                                    : null,
                                imageUrl: () =>
                                    imageUrlController.text.trim().isNotEmpty
                                        ? imageUrlController.text.trim()
                                        : null,
                              );

                              await ref
                                  .read(wishItemProvider.notifier)
                                  .updateItem(updatedItem);

                              ref.invalidate(itemsProvider);

                              // Call the callback to update parent state
                              widget.onItemUpdated(updatedItem);

                              if (context.mounted) {
                                context.router.maybePop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'Wish updated successfully!'),
                                    backgroundColor: widget.itemColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppTheme.radiusMd),
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to update wish: $e'),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppTheme.radiusMd),
                                    ),
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                    gradient: LinearGradient(
                      colors: [
                        widget.itemColor,
                        widget.itemColor.withValues(alpha: 0.8),
                      ],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
