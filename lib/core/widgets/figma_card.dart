import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FigmaCard extends StatelessWidget {
  const FigmaCard({
    super.key,
    required this.child,
    this.variant = FigmaCardVariant.elevated,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final FigmaCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ?? const EdgeInsets.all(AppTheme.spacing16);
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(AppTheme.radius16);

    Widget cardContent = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: effectiveBorderRadius,
        border: _getBorder(),
        boxShadow: _getShadow(),
      ),
      child: child,
    );

    if (margin != null) {
      cardContent = Padding(
        padding: margin!,
        child: cardContent,
      );
    }

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        borderRadius: effectiveBorderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case FigmaCardVariant.elevated:
        return AppTheme.cardWhite;
      case FigmaCardVariant.outlined:
        return AppTheme.backgroundWhite;
      case FigmaCardVariant.filled:
        return AppTheme.cardWhite;
      case FigmaCardVariant.primary:
        return AppTheme.primaryYellow;
    }
  }

  Border? _getBorder() {
    switch (variant) {
      case FigmaCardVariant.outlined:
        return Border.all(
          color: AppTheme.lightGray,
          width: 1,
        );
      default:
        return null;
    }
  }

  List<BoxShadow>? _getShadow() {
    switch (variant) {
      case FigmaCardVariant.elevated:
        return [AppTheme.softShadow];
      case FigmaCardVariant.primary:
        return [AppTheme.mediumShadow];
      default:
        return null;
    }
  }
}

class FigmaWishCard extends StatelessWidget {
  const FigmaWishCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    this.onTap,
  });

  final String title;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FigmaCard(
      variant: FigmaCardVariant.elevated,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color indicator
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
            ),
            child: Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          const Spacer(),

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

          const SizedBox(height: AppTheme.spacing4),

          // Count
          Text(
            '$count items',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.secondaryGray,
            ),
          ),
        ],
      ),
    );
  }
}

class FigmaStatsCard extends StatelessWidget {
  const FigmaStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FigmaCard(
      variant: FigmaCardVariant.primary,
      onTap: onTap,
      child: Row(
        children: [
          // Icon container
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlack.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radius12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryBlack,
              size: 24,
            ),
          ),

          const SizedBox(width: AppTheme.spacing16),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryBlack,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryBlack,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FigmaAddCard extends StatelessWidget {
  const FigmaAddCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FigmaCard(
      variant: FigmaCardVariant.outlined,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryYellow.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radius16),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: AppTheme.primaryBlack,
              size: 24,
            ),
          ),

          const SizedBox(height: AppTheme.spacing12),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlack,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacing4),

          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppTheme.secondaryGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

enum FigmaCardVariant {
  elevated,
  outlined,
  filled,
  primary,
}
