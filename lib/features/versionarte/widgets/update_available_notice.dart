import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

/// The optional-update indicator: a tonal pill that springs down from under
/// the status bar and stays there until the user pushes it away.
///
/// Persistent rather than timed, because an optional update is not news that
/// expires — it is a standing offer. Swiping it up is what closes it, and it
/// stays closed until the version check answers something different.
///
/// Deliberately not buried in a menu: an update the user never sees is an
/// update that never happens.
class UpdateAvailableNotice extends StatefulWidget {
  const UpdateAvailableNotice({
    super.key,
    required this.onUpdate,
    required this.onDismiss,
  });

  final VoidCallback onUpdate;
  final VoidCallback onDismiss;

  @override
  State<UpdateAvailableNotice> createState() => _UpdateAvailableNoticeState();
}

class _UpdateAvailableNoticeState extends State<UpdateAvailableNotice> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();

    // Let the page underneath settle first, then drop in. Arriving on top of
    // a still-animating screen reads as a glitch.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          12,
          TopPadding.of(context) + 4,
          12,
          0,
        ),
        child: SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialDefault(),
          value: _shown ? 1.0 : 0.0,
          active: !reduceMotion,
          builder: (BuildContext context, double t, Widget? child) {
            final double tc = t.clamp(0.0, 1.0);

            return Opacity(
              opacity: tc,
              child: Transform.translate(
                // Travels its own height plus the inset, so it genuinely comes
                // from off-screen rather than fading in place.
                offset: Offset(0, (t - 1) * 120),
                child: child,
              ),
            );
          },
          child: Dismissible(
            key: const ValueKey<String>('versionarte-update-notice'),
            direction: DismissDirection.up,
            onDismissed: (_) => widget.onDismiss(),
            // Structurally a chip with an action on it: stadium container,
            // leading glyph, label, one filled button. The same three parts
            // the blocking pages use, in the same order, at the same ranks.
            // Inverted, the way M3 treats any floating transient surface. A
            // container tone here is the same family as the app behind it, so
            // the pill dissolves into whatever page it lands on. Flipping to
            // the inverse surface makes it read as a separate layer the
            // moment it arrives, without adding a second accent colour.
            child: Material(
              color: cs.inverseSurface,
              shape: const StadiumBorder(),
              clipBehavior: Clip.antiAlias,
              elevation: 3,
              shadowColor: Colors.black.withValues(alpha: 0.3),
              child: InkWell(
                onTap: widget.onUpdate,
                child: Padding(
                  // Left clears the stadium's curve, right hugs the button's
                  // own. Nothing in here is squarer than anything else.
                  padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                  child: Row(
                    children: <Widget>[
                      // A plain glyph, not a filled badge. Morphing shapes
                      // belong to backdrops now, and a filled shape this size
                      // only reads as a second button.
                      // `inversePrimary` is the scheme's accent for exactly
                      // this surface, so the glyph is the one spot of colour
                      // in the text row.
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 18,
                        color: cs.inversePrimary,
                      ),
                      const SizedBox(width: 10),
                      // One line, and no version number. A build string is a
                      // fact for the forced-update screen, where the user
                      // needs to know what they are getting. Here it is just
                      // an offer, so it should sound like one.
                      Expanded(
                        child: Text(
                          'BunPod just got better',
                          style: text.titleSmall?.copyWith(
                            color: cs.onInverseSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: widget.onUpdate,
                        style: FilledButton.styleFrom(
                          // `primaryContainer` rather than `primary`: on an
                          // inverted pill the pale tone is the one that pops,
                          // and it is a guaranteed contrast pair in both
                          // light and dark.
                          backgroundColor: cs.primaryContainer,
                          foregroundColor: cs.onPrimaryContainer,
                          shape: const StadiumBorder(),
                          // Default `padded` pads the button's layout box out
                          // to a 48dp tap target without painting it, which
                          // shows up as more gap above and below the button
                          // than beside it. Sized to 48 instead, so the box
                          // the eye sees is the box the finger gets and the
                          // 8dp inset is even the whole way round.
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: text.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
