library lazy_load_refresh_indicator;

import 'package:flutter/material.dart';

/// The signature for a function that's called when the user has dragged a
/// [LazyLoadRefreshIndicator] far enough to demonstrate that they want the app to
/// refresh. The returned [Future] must complete when the refresh operation is
/// finished.
///
/// Used by [LazyLoadRefreshIndicator.onRefresh].
typedef RefreshCallback = Future<void> Function();

/// A widget that supports the Material "swipe to refresh" idiom and lazy loading.
///
/// When the child's [Scrollable] descendant overscrolls at the top, an animated circular
/// progress indicator is faded into view. When the scroll ends, if the
/// indicator has been dragged far enough for it to become completely opaque,
/// the [onRefresh] callback is called. The callback is expected to update the
/// scrollable's contents and then complete the [Future] it returns. The refresh
/// indicator disappears after the callback's [Future] has completed.
///
/// The trigger mode is configured by [RefreshIndicator.triggerMode].
///
/// When the child's [Scrollable] descendant overscrolls at the end and the
/// overscroll is higher than the [scrollOffset] the [onEndOfPage] callback is called.
///
/// A [LazyLoadRefreshIndicator] can only be used with a vertical scroll view.
class LazyLoadRefreshIndicator extends StatefulWidget {
  /// The offset to take into account when triggering [onEndOfPage] in pixels
  final int scrollOffset;

  /// Called when the [child] reaches the end of the list
  final VoidCallback onEndOfPage;

  /// Used to determine if loading of new data has finished. You should use set this if you aren't using a FutureBuilder or StreamBuilder
  final bool isLoading;

  /// A function that's called when the user has dragged the refresh indicator
  /// far enough to demonstrate that they want the app to refresh. The returned
  /// [Future] must complete when the refresh operation is finished.
  final RefreshCallback onRefresh;

  /// The widget below this widget in the tree.
  ///
  /// The refresh indicator will be stacked on top of this child. The indicator
  /// will appear when child's Scrollable descendant is over-scrolled.
  ///
  /// Typically a [ListView] or [CustomScrollView].
  final Widget child;

  /// The distance from the child's top or bottom edge to where the refresh
  /// indicator will settle. During the drag that exposes the refresh indicator,
  /// its actual displacement may significantly exceed this value.
  ///
  /// Exposed from [RefreshIndicator]
  final double displacement;

  /// The progress indicator's foreground color. The current theme's
  /// [ThemeData.colorScheme.primary] by default.
  ///
  /// Exposed from [RefreshIndicator]
  final Color? color;

  /// The progress indicator's background color. The current theme's
  /// [ThemeData.canvasColor] by default.
  ///
  /// Exposed from [RefreshIndicator]
  final Color? backgroundColor;

  /// A check that specifies whether a [ScrollNotification] should be
  /// handled by this widget.
  ///
  /// By default, checks whether `notification.depth == 0`. Set it to something
  /// else for more complicated layouts.
  ///
  /// Exposed from [RefreshIndicator]
  final ScrollNotificationPredicate notificationPredicate;

  /// {@macro flutter.progress_indicator.ProgressIndicator.semanticsLabel}
  ///
  /// This will be defaulted to [MaterialLocalizations.refreshIndicatorSemanticLabel]
  /// if it is null.
  ///
  /// Exposed from [RefreshIndicator]
  final String? semanticsLabel;

  /// {@macro flutter.progress_indicator.ProgressIndicator.semanticsValue}
  ///
  /// Exposed from [RefreshIndicator]
  final String? semanticsValue;

  /// Defines `strokeWidth` for `RefreshIndicator`.
  ///
  /// By default, the value of `strokeWidth` is 2.0 pixels.
  ///
  /// Exposed from [RefreshIndicator]
  final double strokeWidth;

  /// Defines how this [RefreshIndicator] can be triggered when users overscroll.
  ///
  /// The [RefreshIndicator] can be pulled out in two cases,
  /// 1, Keep dragging if the scrollable widget at the edge with zero scroll position
  ///    when the drag starts.
  /// 2, Keep dragging after overscroll occurs if the scrollable widget has
  ///    a non-zero scroll position when the drag starts.
  ///
  /// If this is [RefreshIndicatorTriggerMode.anywhere], both of the cases above can be triggered.
  ///
  /// If this is [RefreshIndicatorTriggerMode.onEdge], only case 1 can be triggered.
  ///
  /// Defaults to [RefreshIndicatorTriggerMode.onEdge].
  ///
  /// Exposed from [RefreshIndicator]
  final RefreshIndicatorTriggerMode triggerMode;

  /// Creates a lazy load refresh indicator.
  ///
  /// The [child], [onEndOfPage] and [onRefresh] arguments must be non-null.
  /// The default [scrollOffset] is 100 logical pixels, the default [displacement] is 40 logical pixels
  /// and [isLoading] is false.
  const LazyLoadRefreshIndicator({
    Key? key,
    required this.child,
    required this.onEndOfPage,
    required this.onRefresh,
    this.scrollOffset = 100,
    this.isLoading = false,
    this.displacement = 40.0,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 2.0,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
  }) : super(key: key);

  @override
  _LazyLoadRefreshIndicatorState createState() =>
      _LazyLoadRefreshIndicatorState();
}

class _LazyLoadRefreshIndicatorState extends State<LazyLoadRefreshIndicator> {
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isLoading;
  }

  @override
  void didUpdateWidget(LazyLoadRefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isLoading = widget.isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleLoadMoreScroll,
      child: RefreshIndicator(
        onRefresh: widget.onRefresh,
        backgroundColor: widget.backgroundColor,
        color: widget.color,
        displacement: widget.displacement,
        notificationPredicate: widget.notificationPredicate,
        strokeWidth: widget.strokeWidth,
        triggerMode: widget.triggerMode,
        semanticsLabel: widget.semanticsLabel,
        semanticsValue: widget.semanticsValue,
        child: widget.child,
      ),
    );
  }

  bool _handleLoadMoreScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.maxScrollExtent > notification.metrics.pixels &&
          notification.metrics.maxScrollExtent - notification.metrics.pixels <=
              widget.scrollOffset) {
        if (!_isLoading) {
          _isLoading = true;
          widget.onEndOfPage();
        }
      }
    }
    return false;
  }
}
