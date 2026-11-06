import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

/// Springs a newly arrived episode into the list, pushing the rest down.
/// Arrivals come in one after another by [order]. Null shows it as is.
class FeedArrival extends StatefulWidget {
  const FeedArrival({
    super.key,
    required this.order,
    required this.child,
  });

  final int? order;
  final Widget child;

  @override
  State<FeedArrival> createState() => _FeedArrivalState();
}

class _FeedArrivalState extends State<FeedArrival> {
  static const Duration _lead = Duration(milliseconds: 280);
  static const Duration _stagger = Duration(milliseconds: 140);

  late bool _shown = widget.order == null;

  @override
  void initState() {
    super.initState();

    final int? order = widget.order;
    if (order == null) return;

    Future<void>.delayed(_lead + _stagger * order, () {
      if (!mounted) return;

      HapticsHelper.selection();

      setState(() {
        _shown = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.expressiveSpatialDefault(),
      value: _shown ? 1 : 0,
      active: !MediaQuery.disableAnimationsOf(context),
      builder: (context, t, child) {
        final double size = t.clamp(0.0, 1.0);

        return ClipRect(
          child: Align(
            alignment: .topCenter,
            heightFactor: size,
            child: Opacity(
              opacity: size,
              child: Transform.scale(
                scale: 0.88 + 0.12 * t,
                alignment: .topCenter,
                child: child,
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
