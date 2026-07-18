import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:bunpod_flutter/features/onboarding/widgets/show_pick_tile.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, this.onDone});

  /// Invoked when onboarding finishes. Defaults to entering the app home.
  final VoidCallback? onDone;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const int _minPicks = 3;

  final Set<String> _picked = <String>{};

  void _toggle(Channel channel) {
    setState(() {
      if (!_picked.remove(channel.name)) _picked.add(channel.name);
    });
  }

  void _finish() {
    if (widget.onDone != null) {
      widget.onDone!();
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final List<Channel> shows = mockChannels;
    final bool ready = _picked.length >= _minPicks;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  TopPadding.of(context) + 12,
                  24,
                  24,
                ),
                sliver: SliverToBoxAdapter(child: _header(cs, tt)),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: shows.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Channel channel = shows[index];

                    return ShowPickTile(
                      channel: channel,
                      selected: _picked.contains(channel.name),
                      onTap: () => _toggle(channel),
                    );
                  },
                ),
              ),
              // Clearance so the last row scrolls out from under the CTA.
              SliverToBoxAdapter(
                child: SizedBox(height: 132 + BottomPadding.of(context)),
              ),
            ],
          ),

          // ── Bottom CTA over a fade-to-surface scrim ──────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    cs.surface.withValues(alpha: 0.0),
                    cs.surface.withValues(alpha: 0.92),
                    cs.surface,
                  ],
                  stops: const [0.0, 0.45, 0.75],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  40,
                  24,
                  8 + BottomPadding.of(context),
                ),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .stretch,
                  children: [
                    FilledButton(
                      onPressed: ready ? _finish : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: cs.onPrimary,
                        minimumSize: const Size.fromHeight(60),
                        shape: const StadiumBorder(),
                        textStyle: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      child: Text(
                        ready
                            ? 'Follow ${_picked.length} shows'
                            : 'Pick ${_minPicks - _picked.length} more to '
                                  'continue',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(ColorScheme cs, TextTheme tt) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        // Section identity: a quiet tonal pill instead of an app bar.
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: cs.secondaryContainer,
              shape: const StadiumBorder(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: .min,
                children: [
                  Icon(
                    Icons.near_me_rounded,
                    size: 16,
                    color: cs.onSecondaryContainer,
                  ),
                  6.gap,
                  Text(
                    'Popular near you',
                    style: tt.labelLarge?.copyWith(
                      color: cs.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        16.gap,
        Text(
          'Pick your shows.',
          style: tt.headlineLarge?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        12.gap,
        Text(
          'These are trending with listeners around you. Choose '
          '$_minPicks or more and we’ll shape your feed around them.',
          style: tt.bodyLarge?.copyWith(
            color: cs.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
