import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ModernButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}

enum ModernButtonSize {
  small,
  medium,
  large,
}

class ModernButton extends StatelessWidget {
  const ModernButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ModernButtonVariant.primary,
    this.size = ModernButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.gradient,
    this.icon,
    this.fullWidth = false,
  });

  const ModernButton.primary({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = ModernButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.gradient,
    this.icon,
    this.fullWidth = false,
  }) : variant = ModernButtonVariant.primary;

  const ModernButton.secondary({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = ModernButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.gradient,
    this.icon,
    this.fullWidth = false,
  }) : variant = ModernButtonVariant.secondary;

  const ModernButton.outline({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = ModernButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.gradient,
    this.icon,
    this.fullWidth = false,
  }) : variant = ModernButtonVariant.outline;

  const ModernButton.ghost({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = ModernButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.gradient,
    this.icon,
    this.fullWidth = false,
  }) : variant = ModernButtonVariant.ghost;

  const ModernButton.destructive({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = ModernButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.gradient,
    this.icon,
    this.fullWidth = false,
  }) : variant = ModernButtonVariant.destructive;

  final VoidCallback? onPressed;
  final Widget child;
  final ModernButtonVariant variant;
  final ModernButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final Gradient? gradient;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isDisabled && !isLoading;

    final buttonStyle = _getButtonStyle(theme, isEnabled);
    final buttonChild = _buildButtonChild(theme);

    Widget button = ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: buttonStyle,
      child: buttonChild,
    );

    if (fullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  ButtonStyle _getButtonStyle(ThemeData theme, bool isEnabled) {
    final colorScheme = theme.colorScheme;
    final padding = _getPadding();
    final borderRadius = BorderRadius.circular(AppTheme.radiusMd);

    switch (variant) {
      case ModernButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: gradient == null ? colorScheme.primary : null,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.38),
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: AppTheme.elevationSm,
          shadowColor: colorScheme.shadow,
        );

      case ModernButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.38),
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: AppTheme.elevationSm,
        );

      case ModernButtonVariant.outline:
        return OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.38),
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          side: BorderSide(
            color: isEnabled ? colorScheme.primary : colorScheme.outline,
            width: 1.5,
          ),
        );

      case ModernButtonVariant.ghost:
        return TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.38),
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        );

      case ModernButtonVariant.destructive:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.error,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.38),
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: AppTheme.elevationSm,
          shadowColor: colorScheme.error.withValues(alpha: 0.3),
        );
    }
  }

  Widget _buildButtonChild(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ModernButtonVariant.outline ||
                    variant == ModernButtonVariant.ghost
                ? theme.colorScheme.primary
                : Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: AppTheme.spacingSm),
          child,
        ],
      );
    }

    // Handle gradient background for primary button
    if (variant == ModernButtonVariant.primary && gradient != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            child: Container(
              padding: _getPadding(),
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _getFontSize(),
                    fontWeight: FontWeight.w600,
                  ),
                  child: icon != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon,
                                size: _getIconSize(), color: Colors.white),
                            const SizedBox(width: AppTheme.spacingSm),
                            child,
                          ],
                        )
                      : child,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return child;
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ModernButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLg,
          vertical: AppTheme.spacingSm,
        );
      case ModernButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing2xl,
          vertical: AppTheme.spacingMd,
        );
      case ModernButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing3xl,
          vertical: AppTheme.spacingLg,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case ModernButtonSize.small:
        return 16;
      case ModernButtonSize.medium:
        return 20;
      case ModernButtonSize.large:
        return 24;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ModernButtonSize.small:
        return 14;
      case ModernButtonSize.medium:
        return 16;
      case ModernButtonSize.large:
        return 18;
    }
  }
}

class ModernIconButton extends StatelessWidget {
  const ModernIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.variant = ModernButtonVariant.ghost,
    this.size = 40,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final ModernButtonVariant variant;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color? backgroundColor;
    Color? foregroundColor;
    Border? border;

    switch (variant) {
      case ModernButtonVariant.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = Colors.white;
        break;
      case ModernButtonVariant.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = Colors.white;
        break;
      case ModernButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        border = Border.all(color: colorScheme.primary, width: 1.5);
        break;
      case ModernButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        break;
      case ModernButtonVariant.destructive:
        backgroundColor = colorScheme.error;
        foregroundColor = Colors.white;
        break;
    }

    Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Icon(
            icon,
            color: foregroundColor,
            size: size * 0.5,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

class ModernFloatingActionButton extends StatelessWidget {
  const ModernFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.primary;
    final effectiveForegroundColor = foregroundColor ?? Colors.white;
    final effectiveElevation = elevation ?? AppTheme.elevationMd;

    if (gradient != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        elevation: effectiveElevation,
        backgroundColor: Colors.transparent,
        foregroundColor: effectiveForegroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        label: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.2),
                blurRadius: effectiveElevation * 2,
                offset: Offset(0, effectiveElevation),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing2xl,
            vertical: AppTheme.spacingLg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: effectiveForegroundColor),
              if (label != null) ...[
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  label!,
                  style: TextStyle(
                    color: effectiveForegroundColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label!),
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        elevation: effectiveElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: effectiveElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Icon(icon),
    );
  }
}
