import 'package:bunpod/bunpod.dart';
import 'package:expressive_snack/expressive_snack.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:motor/motor.dart';

class OpmlSuggestionDeck extends StatefulWidget {
  const OpmlSuggestionDeck({super.key, required this.suggestions});

  final List<OpmlSuggestion> suggestions;

  @override
  State<OpmlSuggestionDeck> createState() => _OpmlSuggestionDeckState();
}

class _OpmlSuggestionDeckState extends State<OpmlSuggestionDeck> {
  late final OpmlSuggestionsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OpmlSuggestionsCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _choose(Channel option) async {
    HapticsHelper.selection();

    final bool followed = await _cubit.choose(option);

    if (followed) {
      HapticsHelper.success();
      return;
    }

    HapticsHelper.error();

    if (!mounted) return;

    showExpressiveSnack(
      context: context,
      message: 'Couldn’t follow ${option.title}. Try again.',
      icon: Icons.error_outline_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final List<OpmlSuggestion> suggestions = widget.suggestions;

    return BlocBuilder<OpmlSuggestionsCubit, OpmlSuggestionsState>(
      bloc: _cubit,
      builder: (context, deck) {
        final bool done = deck.index >= suggestions.length;

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const .symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Help us out',
                      style: GoogleFonts.unbounded(
                        textStyle: tt.labelLarge,
                        fontWeight: .w600,
                        letterSpacing: -0.3,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  Text(
                    done
                        ? 'Done'
                        : '${deck.index + 1} of ${suggestions.length}',
                    style: tt.labelLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontFeatures: const [
                        .tabularFigures(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            12.gap,
            if (suggestions.length <= 12) ...[
              Padding(
                padding: const .symmetric(horizontal: 8),
                child: Row(
                  children: [
                    for (int i = 0; i < suggestions.length; i++) ...[
                      if (i > 0) 4.gap,
                      _Pill(
                        current: i == deck.index,
                        passed: i < deck.index,
                      ),
                    ],
                  ],
                ),
              ),
              16.gap,
            ],
            AnimatedSize(
              duration: reduceMotion
                  ? .zero
                  : const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              alignment: .topCenter,
              child: AnimatedSwitcher(
                // exits faster than entrances, the entry is a spring
                duration: reduceMotion
                    ? .zero
                    : const Duration(milliseconds: 150),
                layoutBuilder: (current, previous) {
                  return Stack(
                    alignment: .topCenter,
                    children: [...previous, ?current],
                  );
                },
                transitionBuilder: (child, animation) {
                  if (child.key == ValueKey<int>(deck.index)) return child;

                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.9,
                        end: 1,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _SpringIn(
                  key: ValueKey<int>(deck.index),
                  child: done
                      ? _Sorted(
                          followed: deck.followed,
                        )
                      : OpmlSuggestionCard(
                          suggestion: suggestions[deck.index],
                          choosing: deck.choosing,
                          onChoose: _choose,
                          onSkip: () {
                            _cubit.skip();

                            HapticsHelper.light();
                          },
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SpringIn extends StatelessWidget {
  const _SpringIn({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.expressiveSpatialDefault(),
      value: 1,
      from: reduceMotion ? 1 : 0,
      active: !reduceMotion,
      builder: (context, t, child) {
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset((1 - t) * 56, 0),
            child: Transform.scale(
              scale: 0.92 + 0.08 * t,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.current,
    required this.passed,
  });

  final bool current;
  final bool passed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.expressiveSpatialFast(),
      value: current ? 1 : 0,
      active: !reduceMotion,
      builder: (context, t, _) {
        return Container(
          width: 8 + 20 * t.clamp(0.0, 1.2),
          height: 8,
          decoration: ShapeDecoration(
            color: current || passed ? cs.primary : cs.outlineVariant,
            shape: const StadiumBorder(),
          ),
        );
      },
    );
  }
}

class _Sorted extends StatelessWidget {
  const _Sorted({
    required this.followed,
  });

  final int followed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Material(
      color: cs.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(32),
      ),
      child: Padding(
        padding: const .all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: ShapeDecoration(
                color: cs.primary,
                shape: MaterialShapeBorder(
                  shape: MaterialShapes.cookie9Sided,
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                color: cs.onPrimary,
              ),
            ),
            16.gap,
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'All sorted',
                    style: tt.titleMedium?.copyWith(
                      color: cs.onPrimaryContainer,
                      fontWeight: .w700,
                    ),
                  ),
                  2.gap,
                  Text(
                    switch (followed) {
                      0 => 'Thanks for helping out.',
                      1 => '1 more show moved in.',
                      _ => '$followed more shows moved in.',
                    },
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
