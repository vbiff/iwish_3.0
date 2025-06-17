import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/wishlist_item.dart';
import '../../../domain/models/wishlists.dart';
import '../../../core/utils/color_mapper.dart';
import '../../wishlist/wish_item/wish_item_provider.dart';
import '../items/items_provider.dart';

class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({
    super.key,
    required this.onPressed,
    this.wishlist,
  });

  final VoidCallback onPressed;
  final Wishlist? wishlist;

  @override
  ConsumerState<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController photoController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    linkController.dispose();
    priceController.dispose();
    photoController.dispose();
    commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Make a Wish',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add something special to your wishlist',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.onPressed,
                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.wishlist != null
                              ? ColorMapper.toFlutterColor(
                                  widget.wishlist!.color)
                              : Theme.of(context).colorScheme.primary,
                          widget.wishlist != null
                              ? ColorMapper.toFlutterColor(
                                      widget.wishlist!.color)
                                  .withValues(alpha: 0.8)
                              : Theme.of(context).colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: widget.wishlist != null
                              ? ColorMapper.toFlutterColor(
                                      widget.wishlist!.color)
                                  .withValues(alpha: 0.3)
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
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
                        const SizedBox(height: 16),
                        Text(
                          'What do you wish for?',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tell us about your dream item',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Form Fields
                  _buildTextField(
                    controller: nameController,
                    label: 'Wish Name',
                    hint: 'What do you want?',
                    icon: Icons.card_giftcard_rounded,
                    required: true,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: linkController,
                    label: 'Link (Optional)',
                    hint: 'Where can you find it?',
                    icon: Icons.link_rounded,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: priceController,
                    label: 'Price (Optional)',
                    hint: 'How much does it cost?',
                    icon: Icons.attach_money_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: photoController,
                    label: 'Photo URL (Optional)',
                    hint: 'Add a photo link',
                    icon: Icons.photo_rounded,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: commentsController,
                    label: 'Notes (Optional)',
                    hint: 'Any additional details...',
                    icon: Icons.note_rounded,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Bottom Action
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please enter a wish name'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    return;
                  }

                  final itemProvider = ref.read(wishItemProvider.notifier);

                  final newItem = WishlistItem(
                    wishlistId: widget.wishlist?.id ?? '',
                    title: nameController.text.trim(),
                    price: priceController.text.trim().isNotEmpty
                        ? priceController.text.trim()
                        : null,
                    description: commentsController.text.trim().isNotEmpty
                        ? commentsController.text.trim()
                        : null,
                    url: linkController.text.trim().isNotEmpty
                        ? linkController.text.trim()
                        : null,
                  );

                  await itemProvider.createItem(newItem);

                  // Wait for the provider to update
                  await Future.microtask(() {});
                  ref.invalidate(itemsProvider);

                  // Wait for the new data to be available
                  await Future.microtask(() {});
                  widget.onPressed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.wishlist != null
                      ? ColorMapper.toFlutterColor(widget.wishlist!.color)
                      : Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome),
                    const SizedBox(width: 8),
                    Text(
                      'Make This Wish',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
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
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                icon,
                color: widget.wishlist != null
                    ? ColorMapper.toFlutterColor(widget.wishlist!.color)
                    : Theme.of(context).colorScheme.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: widget.wishlist != null
                      ? ColorMapper.toFlutterColor(widget.wishlist!.color)
                      : Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.all(maxLines > 1 ? 20 : 16),
            ),
          ),
        ),
      ],
    );
  }
}
