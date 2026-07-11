abstract final class AssetValues {
  static const String _vectors = 'assets/vectors';
  static const String _images = 'assets/images';

  static const String logoHorizontalLight =
      '$_vectors/logo-horizontal-light.svg';
  static const String logoHorizontalDark = '$_vectors/logo-horizontal-dark.svg';
  static const String logoMark = '$_vectors/logo-mark.svg';

  // The 2025 gradient "Super G" — official conic-gradient SVG isn't
  // renderable by flutter_svg, so it's rasterized once at 340px.
  static const String googleG = '$_images/google-g.png';
  static const String appleLogo = '$_vectors/apple-logo.svg';
}
