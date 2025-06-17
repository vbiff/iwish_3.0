import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FigmaButton extends StatelessWidget {
  const FigmaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = FigmaButtonVariant.primary,
    this.size = FigmaButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.fullWidth = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final FigmaButtonVariant variant;
  final FigmaButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isDisabled && !isLoading;

    Widget buttonChild = Container(
      height: _getHeight(),
      padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding()),
      decoration: BoxDecoration(
        color: _getBackgroundColor(isEnabled),
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        border: _getBorder(isEnabled),
        boxShadow: _getShadow(),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading) ...[
            SizedBox(
              width: _getIconSize(),
              height: _getIconSize(),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(_getTextColor(isEnabled)),
              ),
            ),
            SizedBox(width: AppTheme.spacing8),
          ] else if (icon != null) ...[
            Icon(
              icon,
              size: _getIconSize(),
              color: _getTextColor(isEnabled),
            ),
            SizedBox(width: AppTheme.spacing8),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
              color: _getTextColor(isEnabled),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_getBorderRadius()),
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        child: buttonChild,
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case FigmaButtonSize.small:
        return 36;
      case FigmaButtonSize.medium:
        return 44;
      case FigmaButtonSize.large:
        return 52;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case FigmaButtonSize.small:
        return AppTheme.spacing16;
      case FigmaButtonSize.medium:
        return AppTheme.spacing24;
      case FigmaButtonSize.large:
        return AppTheme.spacing32;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case FigmaButtonSize.small:
        return AppTheme.radius8;
      case FigmaButtonSize.medium:
        return AppTheme.radius12;
      case FigmaButtonSize.large:
        return AppTheme.radius12;
    }
  }

  double _getFontSize() {
    switch (size) {
      case FigmaButtonSize.small:
        return 14;
      case FigmaButtonSize.medium:
        return 16;
      case FigmaButtonSize.large:
        return 16;
    }
  }

  double _getIconSize() {
    switch (size) {
      case FigmaButtonSize.small:
        return 16;
      case FigmaButtonSize.medium:
        return 18;
      case FigmaButtonSize.large:
        return 20;
    }
  }

  Color _getBackgroundColor(bool isEnabled) {
    if (!isEnabled) {
      return AppTheme.lightGray;
    }

    switch (variant) {
      case FigmaButtonVariant.primary:
        return AppTheme.primaryYellow;
      case FigmaButtonVariant.secondary:
        return AppTheme.cardWhite;
      case FigmaButtonVariant.outline:
        return Colors.transparent;
      case FigmaButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _getTextColor(bool isEnabled) {
    if (!isEnabled) {
      return AppTheme.secondaryGray;
    }

    switch (variant) {
      case FigmaButtonVariant.primary:
        return AppTheme.primaryBlack;
      case FigmaButtonVariant.secondary:
        return AppTheme.primaryBlack;
      case FigmaButtonVariant.outline:
        return AppTheme.primaryBlack;
      case FigmaButtonVariant.ghost:
        return AppTheme.primaryBlack;
    }
  }

  Border? _getBorder(bool isEnabled) {
    switch (variant) {
      case FigmaButtonVariant.outline:
        return Border.all(
          color: isEnabled ? AppTheme.primaryBlack : AppTheme.lightGray,
          width: 1,
        );
      default:
        return null;
    }
  }

  List<BoxShadow>? _getShadow() {
    if (variant == FigmaButtonVariant.primary) {
      return [AppTheme.softShadow];
    }
    return null;
  }
}

enum FigmaButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
}

enum FigmaButtonSize {
  small,
  medium,
  large,
}
