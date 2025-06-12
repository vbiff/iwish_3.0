import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PerformanceUtils {
  // Debounce utility for search and input fields
  static void debounce(
    String key,
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, callback);
  }

  static final Map<String, Timer> _debounceTimers = {};

  // Dispose all timers
  static void dispose() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
  }

  // Memory-efficient image loading
  static Widget buildOptimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            );
      },
    );
  }

  // Optimized list builder with automatic disposal
  static Widget buildOptimizedList<T>({
    required List<T> items,
    required Widget Function(BuildContext context, T item, int index)
        itemBuilder,
    ScrollController? controller,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (index >= items.length) return const SizedBox.shrink();
        return itemBuilder(context, items[index], index);
      },
    );
  }

  // Performance monitoring (debug only)
  static void measurePerformance(String operation, VoidCallback callback) {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      callback();
      stopwatch.stop();
      debugPrint('$operation took ${stopwatch.elapsedMilliseconds}ms');
    } else {
      callback();
    }
  }

  // Memory usage monitoring (debug only)
  static void logMemoryUsage(String context) {
    if (kDebugMode) {
      // This is a simplified memory logging
      // In production, you might want to use more sophisticated tools
      debugPrint('Memory check at: $context');
    }
  }
}
