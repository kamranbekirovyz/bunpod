import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:material_ui/material_ui.dart';

/// The color Material would pick as a theme seed for the image at [url].
Future<Color> seedColorFromImage(String url) async {
  final ui.Image image = await _decodeSmall(url);
  final ByteData? pixels = await image.toByteData();
  image.dispose();

  if (pixels == null) throw StateError('Could not read pixels of $url');

  final Uint8List rgba = pixels.buffer.asUint8List();

  return Color(await Isolate.run(() => _bestSeed(rgba)));
}

const int _size = 112;

Future<ui.Image> _decodeSmall(String url) {
  final ImageStream stream = ResizeImage(
    ExtendedNetworkImageProvider(url, cache: true),
    width: _size,
    height: _size,
  ).resolve(ImageConfiguration.empty);

  final Completer<ui.Image> completer = Completer<ui.Image>();
  late final ImageStreamListener listener;

  listener = ImageStreamListener(
    (ImageInfo info, bool _) {
      stream.removeListener(listener);
      completer.complete(info.image);
    },
    onError: (Object error, StackTrace? stackTrace) {
      stream.removeListener(listener);
      completer.completeError(error, stackTrace);
    },
  );

  stream.addListener(listener);

  return completer.future;
}

Future<int> _bestSeed(Uint8List rgba) async {
  final List<int> argb = [
    for (int i = 0; i < rgba.length; i += 4)
      rgba[i + 3] << 24 | rgba[i] << 16 | rgba[i + 1] << 8 | rgba[i + 2],
  ];

  final QuantizerResult result = await QuantizerCelebi().quantize(argb, 128);

  return Score.score(result.colorToCount, desired: 1).first;
}
