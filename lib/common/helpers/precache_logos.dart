import 'package:bunpod/bunpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Decodes both logo variants before the first frame so they don't pop in.
Future<void> precacheLogos() async {
  for (final String path in <String>[
    AssetValues.logoHorizontalLight,
    AssetValues.logoHorizontalDark,
  ]) {
    final SvgAssetLoader loader = SvgAssetLoader(path);

    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }
}
