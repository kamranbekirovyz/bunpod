import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:motor/motor.dart';

class OpmlCoverStack extends StatefulWidget {
  const OpmlCoverStack({super.key, required this.channels});

  final List<Channel> channels;

  @override
  State<OpmlCoverStack> createState() => _OpmlCoverStackState();
}

class _OpmlCoverStackState extends State<OpmlCoverStack> {
  static const double _size = 72;
  static const double _step = 46;
  static const double _ring = 3;

  bool _entered = false;

  @override
  void initState() {
    super.initState();

    // waits out the page transition
    Future<void>.delayed(kThemeAnimationDuration, () {
      if (mounted) setState(() => _entered = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    final int count = widget.channels.length;
    final MaterialShapeBorder shape = MaterialShapeBorder(
      shape: ShapeValues.cover,
    );

    return Semantics(
      label: '${widget.channels.length} shows added',
      excludeSemantics: true,
      // scrolls sideways past the screen edge when there are many
      child: SingleChildScrollView(
        scrollDirection: .horizontal,
        clipBehavior: .none,
        child: SizedBox(
          height: _size,
          width: _size + _step * (count - 1),
          child: SingleMotionBuilder(
            // fans out from a pile
            motion: const MaterialSpringMotion.expressiveSpatialDefault(),
            value: _entered || reduceMotion ? 1 : 0,
            active: !reduceMotion,
            builder: (context, t, _) {
              return Stack(
                clipBehavior: .none,
                children: [
                  // first cover on top
                  for (int i = count - 1; i >= 0; i--)
                    Positioned(
                      left: _step * i * t,
                      child: Transform.rotate(
                        angle: (1 - t.clamp(0.0, 1.0)) * (i % 5 - 2) * 0.12,
                        child: Container(
                          width: _size,
                          height: _size,
                          padding: const .all(_ring),
                          decoration: ShapeDecoration(
                            color: cs.surface,
                            shape: shape,
                          ),
                          child: ClipPath(
                            clipper: ShapeBorderClipper(
                              shape: shape,
                            ),
                            child: SmoothImage(
                              url: widget.channels[i].image ?? '',
                              placeholderColor: widget.channels[i].seed(
                                context,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
