import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';

/// Shown when this build is below the minimum the store allows.
///
/// Not a route. [VersionarteWrapper] lays it over the whole app, so there is
/// nothing behind it to go back to and no gesture that closes it. The only way
/// out is the store.
///
/// Where [AppUnavailablePage] is still and grey, this one moves: shapes bloom
/// off both corners on springs that never line up. Three ranks in the content,
/// one colour each — a filled primary button, a primary container badge, and a
/// neutral version chip.
class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({
    super.key,
    required this.latestVersion,
    required this.onUpdate,
  });

  final String? latestVersion;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return VersionarteBlockLayout(
      background: cs.surface,
      backdrop: ShapeBloomBackdrop(
        color: cs.primaryContainer,
        from: MaterialShapes.cookie7Sided,
        to: MaterialShapes.puffy,
      ),
      // No badge. The corner blooms already carry the shape language, and a
      // third shape in the middle was saying the same thing a second time.
      eyebrow: latestVersion == null
          ? null
          : _VersionChip(version: latestVersion!),
      title: 'A newer BunPod is waiting',
      body: 'Everything you saved is already on the other side.',
      titleStyle: text.headlineMedium?.copyWith(
        color: cs.onSurface,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.4,
      ),
      bodyStyle: text.bodyLarge?.copyWith(
        color: cs.onSurfaceVariant,
        height: 1.4,
      ),
      actions: <Widget>[
        ExpressiveActionButton(
          label: 'Update now',
          icon: Icons.arrow_outward_rounded,
          background: cs.primary,
          foreground: cs.onPrimary,
          onTap: onUpdate,
        ),
      ],
    );
  }
}

/// The version the store has. Neutral, with a leading glyph so it reads as a
/// labelled fact rather than a stray pill.
class _VersionChip extends StatelessWidget {
  const _VersionChip({required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 16, 6),
        decoration: ShapeDecoration(
          color: cs.surfaceContainerHigh,
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // The sparkle says "new". An arrow here would only repeat what
            // the button is already saying.
            Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(width: 7),
            Text(
              'Version $version',
              style: text.labelLarge?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
