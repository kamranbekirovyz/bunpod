import 'package:material_ui/material_ui.dart';

class LoadMoreListener extends StatefulWidget {
  const LoadMoreListener({
    super.key,
    required this.onLoadMore,
    required this.child,
  });

  final VoidCallback onLoadMore;
  final Widget child;

  @override
  State<LoadMoreListener> createState() => _LoadMoreListenerState();
}

class _LoadMoreListenerState extends State<LoadMoreListener> {
  bool _triggered = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        final bool nearEnd = notification.metrics.extentAfter < 600;

        // fire once per visit to the bottom
        if (nearEnd && !_triggered) widget.onLoadMore();
        _triggered = nearEnd;

        return false;
      },
      child: widget.child,
    );
  }
}
