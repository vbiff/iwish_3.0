import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/modern_card.dart';
import '../../core/widgets/modern_button.dart';
import '../../core/utils/color_mapper.dart';
import '../../domain/models/wishlist_item.dart';
import '../home/wishlist_provider/wishlist_provider.dart';

class ItemPage extends ConsumerWidget {
  const ItemPage({
    super.key,
    required this.item,
  });

  final WishlistItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistsAsync = ref.watch(wishlistsProvider);

    // Get the color of the wishlist this item belongs to
    Color itemColor = Theme.of(context).colorScheme.primary;
    if (wishlistsAsync.hasValue && item.wishlistId != null) {
      final itemWishlist = wishlistsAsync.value!.firstWhere(
        (w) => w.id == item.wishlistId,
        orElse: () => wishlistsAsync.value!.first,
      );
      itemColor = ColorMapper.toFlutterColor(itemWishlist.color);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar with gradient
            Container(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing2xl),
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
              child: SafeArea(
                child: Column(
                  children: [
                    // Back button and title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppTheme.spacingLg,
                        AppTheme.spacing2xl,
                        AppTheme.spacingLg,
                        0,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => context.router.maybePop(),
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Wish Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacing2xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    ModernCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(AppTheme.spacingMd),
                                decoration: BoxDecoration(
                                  color: itemColor.withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(AppTheme.radiusSm),
                                ),
                                child: Icon(
                                  Icons.card_giftcard_rounded,
                                  color: itemColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacingLg),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    if (item.price != null &&
                                        item.price!.isNotEmpty) ...[
                                      const SizedBox(
                                          height: AppTheme.spacingSm),
                                      Text(
                                        item.price!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: itemColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (item.description != null &&
                              item.description!.isNotEmpty) ...[
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
                              item.description!,
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

                    // Image Section
                    if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
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
                          ModernCard(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMd),
                              child: Image.network(
                                item.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  padding:
                                      const EdgeInsets.all(AppTheme.spacingXl),
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
                          const SizedBox(height: AppTheme.spacingXl),
                        ],
                      ),

                    // Link Section
                    if (item.url != null && item.url!.isNotEmpty)
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
                            onTap: () async {
                              final url = Uri.parse(item.url!);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.all(AppTheme.spacingMd),
                                  decoration: BoxDecoration(
                                    color: itemColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(
                                        AppTheme.radiusSm),
                                  ),
                                  child: Icon(
                                    Icons.link_rounded,
                                    color: itemColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingLg),
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
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(
                                          height: AppTheme.spacingXs),
                                      Text(
                                        item.url!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingLg),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
