import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:motor/motor.dart';

class OpmlShapeStack extends StatefulWidget {
  const OpmlShapeStack({super.key});

  @override
  State<OpmlShapeStack> createState() => _OpmlShapeStackState();
}

class _OpmlShapeStackState extends State<OpmlShapeStack> {
  static const double _size = 72;
  static const double _step = 46;
  static const double _ring = 3;

  static const List<IconData> _icons = [
    Icons.mic_rounded,
    Icons.headphones_rounded,
    Icons.podcasts_rounded,
    Icons.graphic_eq_rounded,
    Icons.radio_rounded,
  ];

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

    final List<(Color, Color)> colors = [
      (cs.primaryContainer, cs.onPrimaryContainer),
      (cs.secondaryContainer, cs.onSecondaryContainer),
      (cs.tertiaryContainer, cs.onTertiaryContainer),
    ];
    final int count = _icons.length;
    final MaterialShapeBorder shape = MaterialShapeBorder(
      shape: ShapeValues.cover,
    );

    return ExcludeSemantics(
      child: SizedBox(
        height: _size,
        width: _size + _step * (count - 1),
        child: SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialDefault(),
          value: _entered || reduceMotion ? 1 : 0,
          active: !reduceMotion,
          builder: (context, t, _) {
            return Stack(
              clipBehavior: .none,
              children: [
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
                        child: Container(
                          alignment: .center,
                          decoration: ShapeDecoration(
                            color: colors[i % colors.length].$1,
                            shape: shape,
                          ),
                          child: Icon(
                            _icons[i],
                            size: 28,
                            color: colors[i % colors.length].$2,
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
    );
  }
}
