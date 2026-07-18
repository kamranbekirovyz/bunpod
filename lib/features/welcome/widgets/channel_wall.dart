import 'dart:async';
import 'dart:math' as math;

import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

/// A full-bleed mosaic of channel cover art that starts as an edge-to-edge grid
/// of squares. Each tile waits for its own image to load, holds as a square for
/// a beat so you register the cover, then morphs — once — from square into an
/// expressive [MaterialShapes] silhouette, opening up the negative space between
/// covers. Once settled, it stays put.
///
/// Because each shape stays inscribed in its own square cell, tiles are gapless
/// at the start and can never overlap.
///
/// Under reduced-motion the morph is skipped: tiles render statically in their
/// settled shape as soon as their image is ready.
class ChannelWall extends StatelessWidget {
  const ChannelWall({super.key, required this.channels});

  final List<Channel> channels;

  /// Target on-screen tile size; the column count is chosen to land near it.
  static const double _targetTile = 118;

  /// Builds a gapless, full-bleed grid of square cells covering the [w]×[h] box.
  /// Cells cycle through the available channels so the whole background fills.
  static List<_TileSpec> _layoutFor(double w, double h, int channelCount) {
    final int cols = (w / _targetTile).round().clamp(3, 5);
    final double cell = w / cols;
    final int rows = (h / cell).ceil();

    final List<_TileSpec> specs = <_TileSpec>[];
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final int i = row * cols + col;
        specs.add(
          _TileSpec(
            index: i,
            left: col * cell,
            top: row * cell,
            size: cell,
            channelIndex: i % channelCount,
            shape: i % _FloatingTile.shapeCount,
          ),
        );
      }
    }
    return specs;
  }

  @override
  Widget build(BuildContext context) {
    if (channels.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final List<_TileSpec> layout = _layoutFor(
          constraints.maxWidth,
          constraints.maxHeight,
          channels.length,
        );
        return Stack(
          children: <Widget>[
            for (final _TileSpec spec in layout)
              _FloatingTile(
                key: ValueKey<int>(spec.index),
                channel: channels[spec.channelIndex],
                spec: spec,
              ),
          ],
        );
      },
    );
  }
}

class _TileSpec {
  const _TileSpec({
    required this.index,
    required this.left,
    required this.top,
    required this.size,
    required this.channelIndex,
    required this.shape,
  });

  /// Unique running index of this cell — used as the widget key.
  final int index;

  /// Absolute cell geometry, in logical pixels.
  final double left;
  final double top;
  final double size;

  final int channelIndex;

  /// Index into the shared settle-shape table.
  final int shape;
}

class _FloatingTile extends StatefulWidget {
  const _FloatingTile({
    super.key,
    required this.channel,
    required this.spec,
  });

  final Channel channel;
  final _TileSpec spec;

  // The expressive shape each square settles into.
  static final List<RoundedPolygon> _shapes = <RoundedPolygon>[
    MaterialShapes.cookie7Sided,
    MaterialShapes.clover4Leaf,
    MaterialShapes.sunny,
    MaterialShapes.cookie9Sided,
    MaterialShapes.gem,
    MaterialShapes.softBurst,
    MaterialShapes.cookie12Sided,
    MaterialShapes.pentagon,
    MaterialShapes.puffy,
    MaterialShapes.flower,
  ];

  static int get shapeCount => _shapes.length;

  @override
  State<_FloatingTile> createState() => _FloatingTileState();
}

class _FloatingTileState extends State<_FloatingTile> {
  static final RoundedPolygon _square = MaterialShapes.square;

  /// How long the loaded cover is held as a square before it morphs.
  static const Duration _hold = Duration(milliseconds: 300);

  late final ImageProvider _provider = ExtendedNetworkImageProvider(
    widget.channel.image,
    cache: true,
  );
  ImageStream? _stream;
  ImageStreamListener? _listener;
  Timer? _holdTimer;
  bool _loaded = false;

  final math.Random _rng = math.Random();

  // The tile morphs between two shape slots; [_target] (0 or 1) says which one
  // it is currently heading to. It starts as a square heading to its settle
  // shape; tapping swaps the slot it's leaving for a fresh random shape, so it
  // ping-pongs to a new shape on every tap.
  late RoundedPolygon _shapeA = _square;
  late RoundedPolygon _shapeB =
      _FloatingTile._shapes[widget.spec.shape % _FloatingTile._shapes.length];
  double _target = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  void _resolveImage() {
    final ImageStream stream = _provider.resolve(
      createLocalImageConfiguration(context),
    );
    if (stream.key == _stream?.key) return;
    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo image, bool _) => _onReady(),
      onError: (Object _, StackTrace? _) => _onReady(),
    );
    _stream?.removeListener(_listener!);
    _stream = stream;
    _listener = listener;
    _stream!.addListener(listener);
  }

  /// The image is ready (or errored): flip to showing it, hold as a square,
  /// then trigger the single morph. Reduced-motion snaps straight to the shape.
  void _onReady() {
    if (_loaded || !mounted) return;
    setState(() => _loaded = true);

    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduceMotion) {
      setState(() => _target = 1);
      return;
    }
    _holdTimer = Timer(_hold, () {
      if (mounted) setState(() => _target = 1);
    });
  }

  /// Easter egg: tap a cover to morph it to a fresh random shape, on the same
  /// expressive spring. Replaces the slot being left so it never repeats.
  void _onTap() {
    setState(() {
      if (_target == 0) {
        _shapeB = _pickShape(_shapeA);
        _target = 1;
      } else {
        _shapeA = _pickShape(_shapeB);
        _target = 0;
      }
    });
  }

  RoundedPolygon _pickShape(RoundedPolygon avoid) {
    final List<RoundedPolygon> shapes = _FloatingTile._shapes;
    RoundedPolygon s;
    do {
      s = shapes[_rng.nextInt(shapes.length)];
    } while (identical(s, avoid));
    return s;
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    if (_listener != null) _stream?.removeListener(_listener!);
    super.dispose();
  }

  static ShapeBorder _morphBorder(
    RoundedPolygon a,
    RoundedPolygon b,
    double t,
  ) {
    final MaterialShapeBorder na = MaterialShapeBorder(shape: a);
    if (t <= 0) return na;
    final MaterialShapeBorder nb = MaterialShapeBorder(shape: b);
    if (t >= 1) return nb;
    return na.lerpTo(nb, t)!;
  }

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return Positioned(
      left: widget.spec.left,
      top: widget.spec.top,
      width: widget.spec.size,
      height: widget.spec.size,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        // The morph runs on Material expressive spring physics, the same motion
        // the rest of the app morphs with.
        child: SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialFast(),
          value: _target,
          from: 0.0,
          active: !reduceMotion,
          builder: (BuildContext context, double t, Widget? child) {
            final ShapeBorder shape = _morphBorder(
              _shapeA,
              _shapeB,
              t.clamp(0.0, 1.0),
            );
            return ClipPath(
              clipper: ShapeBorderClipper(shape: shape),
              child: child,
            );
          },
          // Smooth fade-in over a seed-colored placeholder. The separate image
          // stream above still drives the shape-morph timing.
          child: SmoothImage(
            url: widget.channel.image,
            placeholderColor: widget.channel.seed,
          ),
        ),
      ),
    );
  }
}
