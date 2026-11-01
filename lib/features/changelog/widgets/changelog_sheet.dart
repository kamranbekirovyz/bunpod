import 'dart:async';

import 'package:bunpod/bunpod.dart';
import 'package:expressive_sheet/expressive_sheet.dart';
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:motor/motor.dart';

class ChangelogSheet extends StatelessWidget {
  const ChangelogSheet({super.key, required this.changelog});

  final Changelog changelog;

  static Future<void> show({
    required BuildContext context,
    required Changelog changelog,
  }) {
    HapticsHelper.soft();

    return showExpressiveSheet<void>(
      context: context,
      builder: (context) {
        return ChangelogSheet(
          changelog: changelog,
        );
      },
    );
  }

  static const Duration _firstRowDelay = Duration(milliseconds: 220);
  static const Duration _rowStagger = Duration(milliseconds: 70);

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final List<String> changes = changelog.changes;
    final String? description = changelog.description;

    return Padding(
      padding: .all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: screenHeight * 0.85 - TopPadding.of(context),
        ),
        child: Material(
          color: cs.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(52),
          ),
          clipBehavior: .antiAlias,
          child: Stack(
            children: [
              Positioned(
                top: -96,
                right: -88,
                child: MorphingShapeBadge(
                  size: 260,
                  from: MaterialShapes.clover8Leaf,
                  to: MaterialShapes.flower,
                  color: cs.tertiaryContainer.withValues(
                    alpha: 0.45,
                  ),
                  motion: const MaterialSpringMotion.standardSpatialSlow(),
                  restBetween: const Duration(
                    milliseconds: 1600,
                  ),
                  turns: 0.08,
                  child: const SizedBox.shrink(),
                ),
              ),
              Padding(
                padding: const .all(24),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .stretch,
                  children: [
                    8.gap,
                    Center(
                      child: _VersionPill(
                        version: changelog.version,
                      ),
                    ),
                    12.gap,
                    Text(
                      'What\'s new',
                      textAlign: .center,
                      style: GoogleFonts.unbounded(
                        textStyle: tt.headlineSmall,
                        fontWeight: .w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (description != null) ...[
                      8.gap,
                      Text(
                        description,
                        textAlign: .center,
                        maxLines: 5,
                        overflow: .ellipsis,
                        style: tt.bodyMedium?.copyWith(
                          height: 1.4,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                    24.gap,
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: .zero,
                        itemCount: changes.length,

                        itemBuilder: (context, index) {
                          final String change = changes.elementAt(index);

                          return _RiseIn(
                            delay: _firstRowDelay + _rowStagger * index,
                            child: _ChangeRow(
                              index: index,
                              total: changes.length,
                              text: change,
                            ),
                          );
                        },
                        separatorBuilder: (_, _) {
                          return MenuSection.tileGap.gap;
                        },
                      ),
                    ),
                    24.gap,
                    ExpressiveActionButton(
                      label: 'Nice, got it',
                      background: cs.primary,
                      foreground: cs.onPrimary,
                      onTap: () {
                        locator<ChangelogCubit>().dismiss();

                        Navigator.of(context).pop();

                        HapticsHelper.light();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VersionPill extends StatelessWidget {
  const _VersionPill({required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: cs.tertiaryContainer,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 12, vertical: 6),
        child: Text(
          'v$version',
          style: GoogleFonts.googleSansCode(
            textStyle: tt.labelLarge,
            fontWeight: .w700,
            color: cs.onTertiaryContainer,
            fontFeatures: const [.tabularFigures()],
          ),
        ),
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({
    required this.index,
    required this.total,
    required this.text,
  });

  final int index;
  final int total;
  final String text;

  static final List<RoundedPolygon> _shapes = [
    MaterialShapes.cookie4Sided,
    MaterialShapes.clover4Leaf,
    MaterialShapes.pentagon,
    MaterialShapes.cookie6Sided,
    MaterialShapes.gem,
    MaterialShapes.puffyDiamond,
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    final (Color background, Color foreground) = switch (index % 3) {
      0 => (cs.primaryContainer, cs.onPrimaryContainer),
      1 => (cs.secondaryContainer, cs.onSecondaryContainer),
      _ => (cs.tertiaryContainer, cs.onTertiaryContainer),
    };

    return Material(
      color: cs.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: MenuSection.radiusFor(index, total),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: .center,
              decoration: ShapeDecoration(
                color: background,
                shape: MaterialShapeBorder(
                  shape: _shapes[index % _shapes.length],
                ),
              ),
              child: Text(
                '${index + 1}',
                style: GoogleFonts.googleSansCode(
                  textStyle: tt.titleSmall,
                  fontWeight: .w700,
                  color: foreground,
                ),
              ),
            ),
            16.gap,
            Expanded(
              child: Text(
                text,
                style: tt.bodyLarge?.copyWith(height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiseIn extends StatefulWidget {
  const _RiseIn({required this.delay, required this.child});

  final Duration delay;
  final Widget child;

  @override
  State<_RiseIn> createState() => _RiseInState();
}

class _RiseInState extends State<_RiseIn> {
  bool _shown = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(widget.delay, () {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduceMotion) return widget.child;

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.expressiveSpatialFast(),
      value: _shown ? 1 : 0,
      child: widget.child,
      builder: (context, t, child) {
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 28),
            child: Transform.scale(
              scale: 0.94 + 0.06 * t,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
