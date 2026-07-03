import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';

/// App-wide smooth network image loading.
///
/// Fades art in over a solid placeholder instead of popping, and shows a subtle
/// fallback on error. Images already in memory appear instantly (no flash),
/// because [ImageFade.syncDuration] is zero. Use this everywhere the app shows
/// remote cover art or avatars.
class SmoothImage extends StatelessWidget {
  const SmoothImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholderColor,
    this.placeholderChild,
    this.errorChild,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  /// Solid fill shown while loading and behind [placeholderChild]. Defaults to
  /// the theme's [ColorScheme.surfaceContainerHighest].
  final Color? placeholderColor;

  /// Optional centered widget over the placeholder (e.g. a podcast glyph).
  final Widget? placeholderChild;

  /// Optional centered widget for the error state. Defaults to a muted
  /// broken-image icon.
  final Widget? errorChild;

  /// Material 3 emphasized-decelerate easing — fast in, soft landing — the
  /// expressive curve for an element entering the screen.
  static const Curve _emphasizedDecelerate = Cubic(0.05, 0.7, 0.1, 1.0);

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final Color bg = placeholderColor ?? cs.surfaceContainerHighest;

    Widget fill(Widget? child) => Container(
      color: bg,
      alignment: Alignment.center,
      child: child,
    );

    return ImageFade(
      image: NetworkImage(url),
      fit: fit,
      width: width,
      height: height,
      curve: _emphasizedDecelerate,
      duration: const Duration(milliseconds: 320),
      // Already-cached images show immediately, with no fade flash.
      syncDuration: Duration.zero,
      placeholder: fill(placeholderChild),
      errorBuilder: (BuildContext context, Object exception) => fill(
        errorChild ??
            Icon(
              Icons.image_not_supported_outlined,
              size: 20,
              color: cs.onSurfaceVariant,
            ),
      ),
    );
  }
}
