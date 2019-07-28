library lazy_load_refresh_indicator;

import 'package:flutter/material.dart';

/// The signature for a function that's called when the user has dragged a
/// [LazyLoadRefreshIndicator] far enough to demonstrate that they want the app to
/// refresh. The returned [Future] must complete when the refresh operation is
/// finished.
///
/// Used by [LazyLoadRefreshIndicator.onRefresh].
typedef RefreshCallback = Future<void> Function();

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

  const LazyLoadRefreshIndicator({
    Key key,
    this.scrollOffset = 100,
    @required this.onEndOfPage,
    this.isLoading = false,
    @required this.onRefresh,
    @required this.child,
  })  : assert(child != null),
        assert(onRefresh != null),
        assert(onEndOfPage != null),
        super(key: key);

  @override
  _LazyLoadRefreshIndicatorState createState() => _LazyLoadRefreshIndicatorState();
}

class _LazyLoadRefreshIndicatorState extends State<LazyLoadRefreshIndicator> {
  bool _isLoading;

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
      child: RefreshIndicator(
        child: widget.child,
        onRefresh: widget.onRefresh,
      ),
      onNotification: _handleLoadMoreScroll,
    );
  }

  bool _handleLoadMoreScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.maxScrollExtent > notification.metrics.pixels &&
          notification.metrics.maxScrollExtent - notification.metrics.pixels <= widget.scrollOffset) {
        if (!_isLoading) {
          _isLoading = true;
          widget.onEndOfPage();
        }
      }
    }
    return false;
  }
}
