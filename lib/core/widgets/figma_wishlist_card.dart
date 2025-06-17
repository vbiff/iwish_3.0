import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FigmaWishlistCard extends StatelessWidget {
  const FigmaWishlistCard({
    super.key,
    required this.title,
    required this.itemCount,
    required this.color,
    this.onTap,
    this.isSelected = false,
  });

  final String title;
  final int itemCount;
  final Color color;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryYellow : AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.cardShadow,
          border: isSelected
              ? Border.all(color: AppTheme.primaryYellow, width: 2)
              : null,
        ),
        child: Row(
          children: [
            // Color indicator circle
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: AppTheme.spacing12),

            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlack,
                  letterSpacing: -0.2,
                ),
              ),
            ),

            // Item count
            Text(
              '$itemCount items',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.secondaryGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FigmaWishItemCard extends StatelessWidget {
  const FigmaWishItemCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.price,
    this.onTap,
    this.onEdit,
  });

  final String title;
  final String? imageUrl;
  final String? price;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLg),
              ),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlack,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (price != null && price!.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      price!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryYellow,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppTheme.spacing12),

                  // Edit button (external link icon like in Figma)
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacing8),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundWhite,
                          borderRadius: BorderRadius.circular(AppTheme.radius8),
                          border: Border.all(
                            color: AppTheme.lightGray,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.open_in_new_rounded,
                          size: 16,
                          color: AppTheme.secondaryGray,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.backgroundWhite,
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: AppTheme.lightGray,
        ),
      ),
    );
  }
}

class FigmaAddItemCard extends StatelessWidget {
  const FigmaAddItemCard({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryYellow,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.cardShadow,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                size: 32,
                color: AppTheme.primaryBlack,
              ),
              SizedBox(height: AppTheme.spacing8),
              Text(
                'Add item',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlack,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
