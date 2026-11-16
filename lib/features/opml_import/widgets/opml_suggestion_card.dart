import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:motor/motor.dart';

class OpmlSuggestionCard extends StatelessWidget {
  const OpmlSuggestionCard({
    super.key,
    required this.suggestion,
    required this.choosing,
    required this.onChoose,
    required this.onSkip,
  });

  final OpmlSuggestion suggestion;
  final int? choosing;
  final ValueChanged<Channel> onChoose;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final List<Channel> options = suggestion.options.take(3).toList();
    final bool busy = choosing != null;

    return Material(
      color: cs.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(32),
      ),
      clipBehavior: .antiAlias,
      child: Padding(
        padding: const .fromLTRB(12, 16, 12, 8),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const .symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Which one is',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  2.gap,
                  Text(
                    '“${suggestion.feed.title ?? 'this show'}”?',
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: GoogleFonts.unbounded(
                      textStyle: tt.titleMedium,
                      fontWeight: .w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),
            16.gap,
            for (final (int i, Channel option) in options.indexed) ...[
              if (i > 0) MenuSection.tileGap.gap,
              _OptionRow(
                channel: option,
                borderRadius: .vertical(
                  top: .circular(i == 0 ? 20 : 4),
                  bottom: .circular(i == options.length - 1 ? 20 : 4),
                ),
                selected: option.id == choosing,
                dimmed: busy && option.id != choosing,
                onTap: busy ? null : () => onChoose(option),
              ),
            ],
            4.gap,
            TextButton(
              onPressed: busy ? null : onSkip,
              style: TextButton.styleFrom(
                minimumSize: const .fromHeight(48),
              ),
              child: const Text('None of these'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.channel,
    required this.borderRadius,
    required this.selected,
    required this.dimmed,
    required this.onTap,
  });

  final Channel channel;
  final BorderRadius borderRadius;
  final bool selected;
  final bool dimmed;
  final VoidCallback? onTap;

  static final MaterialShapeBorder _square = MaterialShapeBorder(
    shape: MaterialShapes.square,
  );
  static final MaterialShapeBorder _cover = MaterialShapeBorder(
    shape: ShapeValues.cover,
  );
  static final MaterialShapeBorder _circle = MaterialShapeBorder(
    shape: MaterialShapes.circle,
  );
  static final MaterialShapeBorder _cookie = MaterialShapeBorder(
    shape: MaterialShapes.cookie7Sided,
  );

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return Semantics(
      button: true,
      selected: selected,
      label: 'Follow ${channel.title} by ${channel.author}',
      excludeSemantics: true,
      child: AnimatedOpacity(
        opacity: dimmed ? 0.38 : 1,
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: cs.surfaceContainerHigh,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          clipBehavior: .antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const .fromLTRB(10, 10, 12, 10),
              child: SingleMotionBuilder(
                motion: const MaterialSpringMotion.expressiveSpatialFast(),
                value: selected ? 1 : 0,
                active: !reduceMotion,
                builder: (context, t, _) {
                  final double tc = t.clamp(0.0, 1.0);

                  return Row(
                    children: [
                      ClipPath(
                        clipper: ShapeBorderClipper(
                          shape: _square.lerpTo(_cover, tc)!,
                        ),
                        child: SizedBox.square(
                          dimension: 56,
                          child: SmoothImage(
                            url: channel.image ?? '',
                            placeholderColor: channel.seed(context),
                          ),
                        ),
                      ),
                      14.gap,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          mainAxisSize: .min,
                          children: [
                            Text(
                              channel.title ?? '',
                              maxLines: 2,
                              overflow: .ellipsis,
                              style: tt.titleSmall?.copyWith(
                                fontWeight: .w600,
                              ),
                            ),
                            2.gap,
                            Text(
                              channel.author ?? '',
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      12.gap,
                      Container(
                        width: 40,
                        height: 40,
                        alignment: .center,
                        decoration: ShapeDecoration(
                          color: Color.lerp(
                            cs.secondaryContainer,
                            cs.primary,
                            tc,
                          ),
                          shape: _circle.lerpTo(_cookie, tc)!,
                        ),
                        child: selected
                            ? SizedBox.square(
                                dimension: 28,
                                child: LoadingIndicator(
                                  activeIndicatorColor: cs.onPrimary,
                                ),
                              )
                            : Icon(
                                Icons.add_rounded,
                                size: 20,
                                color: cs.onSecondaryContainer,
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
