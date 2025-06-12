import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/models/wishlist_color.dart';
import '../../../domain/models/wishlists.dart';
import '../wishlist_provider/wishlist_provider.dart';

class NewWishlistPage extends ConsumerStatefulWidget {
  const NewWishlistPage({
    super.key,
    this.existingWishlist,
  });

  final Wishlist? existingWishlist;

  @override
  ConsumerState<NewWishlistPage> createState() => _NewWishlistPageState();
}

class _NewWishlistPageState extends ConsumerState<NewWishlistPage> {
  final _titleController = TextEditingController();
  WishlistColor _selectedColor = WishlistColor.orange;

  bool get isEditing => widget.existingWishlist != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.existingWishlist!.title;
      _selectedColor = widget.existingWishlist!.color;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      isEditing ? 'Edit Wishlist' : 'Create Wishlist',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    onPressed: _saveWishlist,
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getColorForWishlist(_selectedColor),
                            _getColorForWishlist(_selectedColor)
                                .withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: _getColorForWishlist(_selectedColor)
                                .withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isEditing
                                ? 'Update Your Wishlist'
                                : 'Create Your Dream List',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isEditing
                                ? 'Make changes to organize your wishes better'
                                : 'Give your wishlist a name and choose a color theme',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Title Section
                    Text(
                      'Wishlist Name',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _titleController,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Enter wishlist name...',
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.all(20),
                          prefixIcon: Icon(
                            Icons.edit_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Color Section
                    Text(
                      'Choose Color Theme',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pick a color that represents your wishlist mood',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Color Grid
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: WishlistColor.values.length,
                        itemBuilder: (context, index) {
                          final color = WishlistColor.values[index];
                          final isSelected = _selectedColor == color;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: _getColorForWishlist(color),
                                borderRadius: BorderRadius.circular(16),
                                border: isSelected
                                    ? Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        width: 3,
                                      )
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: _getColorForWishlist(color)
                                        .withValues(alpha: 0.4),
                                    blurRadius: isSelected ? 15 : 8,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForWishlist(WishlistColor color) {
    switch (color) {
      case WishlistColor.orange:
        return const Color(0xFFFF8A65);
      case WishlistColor.blue:
        return const Color(0xFF42A5F5);
      case WishlistColor.green:
        return const Color(0xFF66BB6A);
      case WishlistColor.purple:
        return const Color(0xFFAB47BC);
      case WishlistColor.red:
        return const Color(0xFFEF5350);
      case WishlistColor.yellow:
        return const Color(0xFFFFEE58);
      case WishlistColor.pink:
        return const Color(0xFFEC407A);
      case WishlistColor.teal:
        return const Color(0xFF26A69A);
    }
  }

  void _saveWishlist() {
    if (_titleController.text.isNotEmpty) {
      if (isEditing) {
        // Update existing wishlist
        final updatedWishlist = Wishlist(
          id: widget.existingWishlist!.id,
          title: _titleController.text,
          userId: widget.existingWishlist!.userId,
          createdAt: widget.existingWishlist!.createdAt,
          color: _selectedColor,
        );
        ref.read(wishlistsProvider.notifier).updateWishlist(updatedWishlist);
      } else {
        // Create new wishlist
        ref.read(wishlistsProvider.notifier).createWishlist(
              Wishlist(
                id: '', // Let database auto-generate ID
                userId: Supabase.instance.client.auth.currentUser?.id ?? '',
                createdAt: DateTime.now(),
                title: _titleController.text,
                color: _selectedColor,
              ),
            );
      }

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Wishlist updated!' : 'Wishlist created!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      context.router.maybePop();
    } else {
      // Show error feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a wishlist name'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
