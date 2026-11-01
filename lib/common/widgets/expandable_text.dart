import 'dart:ui' show lerpDouble;

import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({
    super.key,
    required this.text,
    required this.style,
    required this.scheme,
    this.maxLines = 5,
  });

  final String text;
  final TextStyle? style;
  final ColorScheme scheme;
  final int maxLines;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  void _expand() {
    if (_expanded) return;

    HapticsHelper.selection();
    setState(() {
      _expanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final TextSpan span = TextSpan(text: widget.text, style: widget.style);
        final TextDirection direction = Directionality.of(context);
        final TextScaler scaler = MediaQuery.textScalerOf(context);

        final TextPainter clamped = TextPainter(
          text: span,
          textDirection: direction,
          textScaler: scaler,
          maxLines: widget.maxLines,
        )..layout(maxWidth: constraints.maxWidth);

        final bool overflows = clamped.didExceedMaxLines;
        final double collapsedHeight = clamped.height;
        final double lineHeight = clamped.preferredLineHeight;
        clamped.dispose();

        if (!overflows) return Text(widget.text, style: widget.style);

        final TextPainter full = TextPainter(
          text: span,
          textDirection: direction,
          textScaler: scaler,
        )..layout(maxWidth: constraints.maxWidth);
        final double fullHeight = full.height;
        full.dispose();

        return SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialDefault(),
          value: _expanded ? 1 : 0,
          active: !reduceMotion,
          builder: (context, t, _) {
            final double height = lerpDouble(
              collapsedHeight,
              fullHeight,
              t,
            )!.clamp(collapsedHeight, fullHeight);

            // 1 while collapsed, 0 once open. Drives the bottom fade and the
            // chevron, which both exist only to say "there's more below".
            final double hint = (1 - t).clamp(0.0, 1.0);

            return Column(
              crossAxisAlignment: .start,
              children: [
                GestureDetector(
                  behavior: .opaque,
                  onTap: _expanded ? null : _expand,
                  child: ShaderMask(
                    blendMode: .dstIn,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: .topCenter,
                        end: .bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                          Colors.white.withValues(alpha: 1 - hint),
                        ],
                        stops: [
                          0,
                          (1 - lineHeight * 1.5 / bounds.height).clamp(0, 1),
                          1,
                        ],
                      ).createShader(bounds);
                    },
                    child: ClipRect(
                      child: SizedBox(
                        height: height,
                        child: OverflowBox(
                          alignment: .topLeft,
                          maxHeight: double.infinity,
                          child: Text(widget.text, style: widget.style),
                        ),
                      ),
                    ),
                  ),
                ),
                if (hint > 0)
                  _ExpandChevron(
                    hint: hint,
                    scheme: widget.scheme,
                    onPressed: _expanded ? null : _expand,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ExpandChevron extends StatelessWidget {
  const _ExpandChevron({
    required this.hint,
    required this.scheme,
    required this.onPressed,
  });

  final double hint;
  final ColorScheme scheme;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: .topCenter,
        heightFactor: hint,
        child: Opacity(
          opacity: hint,
          child: Transform.scale(
            scale: hint,
            child: Center(
              child: IconButton(
                onPressed: onPressed,
                tooltip: 'Read more',
                color: scheme.onSurfaceVariant,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
