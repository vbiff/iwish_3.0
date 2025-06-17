import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import 'modern_card.dart';
import 'modern_button.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.skipLoadingOnRefresh = true,
    this.skipLoadingOnReload = false,
    this.skipError = false,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final bool skipLoadingOnRefresh;
  final bool skipLoadingOnReload;
  final bool skipError;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipLoadingOnReload: skipLoadingOnReload,
      skipError: skipError,
      data: data,
      loading: loading ?? () => const ModernLoadingWidget(),
      error: error ??
          (err, stack) => ModernErrorWidget(
                error: err,
                stackTrace: stack,
                onRetry: () {
                  // This will be handled by the parent widget
                },
              ),
    );
  }
}

class ModernLoadingWidget extends StatelessWidget {
  const ModernLoadingWidget({
    super.key,
    this.message = 'Loading...',
    this.showMessage = true,
  });

  final String message;
  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing2xl),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
                if (showMessage) ...[
                  const SizedBox(height: AppTheme.spacingLg),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ModernErrorWidget extends StatelessWidget {
  const ModernErrorWidget({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
    this.title = 'Something went wrong',
    this.showDetails = false,
  });

  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final String title;
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing2xl),
        child: ModernCard(
          padding: const EdgeInsets.all(AppTheme.spacing2xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                _getErrorMessage(error),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: showDetails ? null : 3,
                overflow: showDetails ? null : TextOverflow.ellipsis,
              ),
              if (showDetails && stackTrace != null) ...[
                const SizedBox(height: AppTheme.spacingMd),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(
                    stackTrace.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              if (onRetry != null) ...[
                const SizedBox(height: AppTheme.spacingXl),
                ModernButton.primary(
                  onPressed: onRetry,
                  icon: Icons.refresh_rounded,
                  child: const Text('Try Again'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getErrorMessage(Object error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error.toString();
  }
}

class ModernEmptyWidget extends StatelessWidget {
  const ModernEmptyWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.actionLabel,
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing3xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing2xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius2xl),
              ),
              child: Icon(
                icon,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppTheme.spacing2xl),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: AppTheme.spacing2xl),
              ModernButton.primary(
                onPressed: action,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ModernRefreshIndicator extends StatelessWidget {
  const ModernRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
    this.backgroundColor,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? theme.colorScheme.primary,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      strokeWidth: 3,
      displacement: 60,
      child: child,
    );
  }
}

class ModernSliver extends StatelessWidget {
  const ModernSliver({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: child);
  }
}

class ModernSliverPadding extends StatelessWidget {
  const ModernSliverPadding({
    super.key,
    required this.padding,
    required this.sliver,
  });

  final EdgeInsetsGeometry padding;
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: sliver,
    );
  }
}
