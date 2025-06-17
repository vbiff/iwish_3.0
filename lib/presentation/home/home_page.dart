import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/wishlists.dart';
import '../../core/providers/app_providers.dart';
import '../../core/widgets/figma_wishlist_card.dart';
import '../wishlist/wishlist_page.dart';
import 'widget/new_wishlist_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistsAsync = ref.watch(wishlistsNotifierProvider);

    return DefaultTabController(
      initialIndex: 0,
      length: (wishlistsAsync.valueOrNull?.length ?? 0) + 1,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Image.asset(
            'assets/images/iwish.png',
            width: 100,
            height: 100,
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'I wish',
                style: TextStyle(
                  color: AppTheme.primaryYellow,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Events',
                style: TextStyle(
                  color: AppTheme.secondaryGray,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacing24),
            // Wishlists tabs
            wishlistsAsync.when(
              data: (wishlists) {
                if (wishlists.isEmpty) {
                  return const EmptyState();
                }

                // Update tab controller length when wishlists change

                return Expanded(
                  child: Column(
                    children: [
                      // Tab bar
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing16,
                        ),
                        child: TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            indicator: BoxDecoration(
                              color: AppTheme.primaryYellow,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radius12),
                            ),
                            labelColor: AppTheme.primaryBlack,
                            unselectedLabelColor: AppTheme.secondaryGray,
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            dividerColor: Colors.transparent,
                            labelPadding: EdgeInsets.zero,
                            onTap: (index) {},
                            tabs: [
                              Tab(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacing8,
                                    vertical: AppTheme.spacing8,
                                  ),
                                  child: Text('All'),
                                ),
                              ),
                              ...wishlists.map((wishlist) {
                                return Tab(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppTheme.spacing8,
                                      vertical: AppTheme.spacing8,
                                    ),
                                    child: Text(wishlist.title),
                                  ),
                                );
                              }),
                            ]),
                      ),

                      const SizedBox(height: AppTheme.spacing64),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing16,
                              ),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'I wish',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppTheme.primaryBlack,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.primaryYellow),
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: AppTheme.secondaryGray,
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    Text(
                      'Failed to load wishlists',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryGray,
                          ),
                      textAlign: TextAlign.center,
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

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing32),
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius2xl),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                size: 64,
                color: AppTheme.primaryYellow,
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text(
              'No Wishlists Yet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              'Create your first wishlist to get started',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.secondaryGray,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing32),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewWishlistPage(),
                ),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Wishlist'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing32,
                  vertical: AppTheme.spacing16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WishListItems extends StatelessWidget {
  const WishListItems({
    super.key,
    required this.wishlist,
    required this.itemsAsync,
  });

  final Wishlist wishlist;
  final AsyncValue itemsAsync;

  @override
  Widget build(BuildContext context) {
    return itemsAsync.when(
      data: (allItems) {
        final items =
            allItems.where((item) => item.wishlistId == wishlist.id).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: AppTheme.spacing32),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: AppTheme.spacing16,
              mainAxisSpacing: AppTheme.spacing16,
            ),
            itemCount: items.length + 1, // +1 for add button
            itemBuilder: (context, index) {
              if (index == items.length) {
                // Add item card
                return FigmaAddItemCard(
                  onTap: () => // TODO: Navigate to add item page
                      ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Add item to ${wishlist.title}'),
                      backgroundColor: AppTheme.primaryBlack,
                    ),
                  ),
                );
              }

              final item = items[index];
              return FigmaWishItemCard(
                title: item.title,
                imageUrl: item.imageUrl,
                price: item.price,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WishlistPage(
                      wishlistObject:
                          null, // Will be determined by item's wishlist
                      wishlist: const [], // Empty list for now
                    ),
                  ),
                ),
                onEdit: () => // TODO: Navigate to edit item page
                    ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Edit ${item.title}'),
                    backgroundColor: AppTheme.primaryBlack,
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryYellow),
        ),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Failed to load items: $error',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryGray,
              ),
        ),
      ),
    );
  }
}
