import 'package:material_ui/material_ui.dart';

class ProgressiveFade extends StatelessWidget {
  const ProgressiveFade({
    super.key,
    required this.child,
    this.edge = Alignment.topCenter,
    this.height = 120,
    this.inset = 0,
  });

  final Widget child;
  final Alignment edge;
  final double height;
  final double inset;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: .dstIn,
      shaderCallback: (Rect bounds) {
        final double start = (inset / bounds.height).clamp(0.0, 1.0);
        final double end = ((inset + height) / bounds.height).clamp(0.0, 1.0);
        final double span = end - start;

        return LinearGradient(
          begin: edge,
          end: Alignment(-edge.x, -edge.y),
          colors: const [
            Color(0x00FFFFFF),
            Color(0x00FFFFFF),
            Color(0x26FFFFFF),
            Color(0x66FFFFFF),
            Color(0xB3FFFFFF),
            Color(0xFFFFFFFF),
          ],
          stops: [
            0,
            start,
            start + span * 0.25,
            start + span * 0.5,
            start + span * 0.75,
            end,
          ],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
