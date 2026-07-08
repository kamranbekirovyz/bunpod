import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:material_shapes/material_shapes.dart' as shapes;

// Tokens from the Compose Material 3 CircularProgressIndicatorTokens (v0_7_0).
const double _kActiveThickness = 4;
const double _kTrackActiveSpace = 4;
const double _kActiveWaveWavelength = 15;
const double _kWaveContainerSize = 48;

// WavyProgressIndicatorDefaults.indicatorAmplitude: the wave is at its max
// amplitude only when the progress is between these two values.
const double _kFullAmplitudeProgressMin = 0.1;
const double _kFullAmplitudeProgressMax = 0.95;

const int _kMinCircularVertexCount = 5;

// Minimum wave-offset animation duration to ensure we don't overwhelm the CPU.
const int _kMinAnimationDurationMs = 50;

// Indeterminate transition specs from the Compose ProgressIndicator.kt.
const int _kCircularAnimationProgressDurationMs = 6000;
const int _kAdditionalRotationDelayMs = 1500;
const int _kAdditionalRotationDurationMs = 300;
const double _kGlobalRotationDegreesTarget = 1080;
const double _kIndeterminateMinProgress = 0.1;
const double _kIndeterminateMaxProgress = 0.87;

// MotionTokens easings.
const Cubic _kStandardEasing = Cubic(0.2, 0, 0, 1);
const Cubic _kEmphasizedAccelerateEasing = Cubic(0.3, 0, 0.8, 0.15);
const Cubic _kEmphasizedDecelerateEasing = Cubic(0.05, 0.7, 0.1, 1);

/// A Material Design wavy circular progress indicator.
///
/// A faithful port of the Compose Material 3 expressive
/// `CircularWavyProgressIndicator`: the active indicator morphs between a
/// circle and a rounded star (built from `RoundedPolygon`s, one wave per
/// vertex), and the wave's motion is created by shifting the drawn segment
/// along the path while counter-rotating it, so the pattern travels around
/// the ring.
///
/// There are two kinds of circular progress indicators:
///
///  * _Determinate_. Determinate progress indicators have a specific value at
///    each point in time, and the value should increase monotonically from 0.0
///    to 1.0, at which time the indicator is complete. To create a determinate
///    progress indicator, use a non-null [value] between 0.0 and 1.0.
///  * _Indeterminate_. Indeterminate progress indicators do not have a specific
///    value at each point in time and instead indicate that progress is being
///    made without indicating how much progress remains. To create an
///    indeterminate progress indicator, use a null [value].
class CircularWavyProgressIndicator extends StatefulWidget {
  /// Creates a Material Design wavy circular progress indicator.
  const CircularWavyProgressIndicator({
    this.value,
    this.color,
    this.trackColor,
    this.strokeWidth,
    this.trackGap,
    this.amplitude = 1,
    this.wavelength,
    this.waveSpeed,
    this.semanticsLabel,
    this.semanticsValue,
    super.key,
  }) : assert(
         strokeWidth == null || strokeWidth > 0,
         'strokeWidth has to be greater than zero.',
       ),
       assert(
         trackGap == null || trackGap >= 0,
         'trackGap must not be negative.',
       ),
       assert(
         amplitude >= 0 && amplitude <= 1,
         'amplitude has to be in range [0, 1].',
       ),
       assert(
         wavelength == null || wavelength > 0,
         'wavelength has to be greater than zero.',
       ),
       assert(
         waveSpeed == null || waveSpeed >= 0,
         'waveSpeed must not be negative.',
       );

  /// {@macro flutter.material.WavyLinearProgressIndicator.value}
  final double? value;

  /// The color of the [CircularWavyProgressIndicator]'s active indicator.
  ///
  /// If null, then the [ColorScheme.primary] will be used.
  final Color? color;

  /// The color of the [CircularWavyProgressIndicator]'s track.
  ///
  /// If null, then the [ColorScheme.secondaryContainer] will be used.
  final Color? trackColor;

  /// The width of the active indicator and track.
  ///
  /// If null, then defaults to 4.
  final double? strokeWidth;

  /// The size of the gap between active indicator and track.
  ///
  /// If null, then defaults to 4.
  final double? trackGap;

  /// The max amplitude of the active indicator wave, where 0.0 represents no
  /// amplitude (a plain circle) and 1.0 represents the full wave depth.
  ///
  /// For a determinate indicator the wave is only displayed while the
  /// progress is between 10% and 95%, ramping in and out with the spec's
  /// amplitude animations.
  ///
  /// Defaults to 1.
  final double amplitude;

  /// The preferred length of a wave, measured along the ring.
  ///
  /// The actual wavelength may end up different, as the wave count is rounded
  /// to a whole number so the wave meets itself seamlessly around the ring.
  ///
  /// If null, then defaults to 15.
  final double? wavelength;

  /// The speed of the active indicator wave in logical pixels per second,
  /// measured along the ring's circumference.
  ///
  /// If null, then defaults to [wavelength], which moves the wave by one
  /// wavelength per second.
  final double? waveSpeed;

  /// {@macro flutter.material.WavyLinearProgressIndicator.semanticsLabel}
  final String? semanticsLabel;

  /// {@macro flutter.material.WavyLinearProgressIndicator.semanticsValue}
  final String? semanticsValue;

  @override
  State<CircularWavyProgressIndicator> createState() =>
      _CircularWavyProgressIndicatorState();
}

class _CircularWavyProgressIndicatorState
    extends State<CircularWavyProgressIndicator>
    with TickerProviderStateMixin {
  final _CircularShapes _shapes = _CircularShapes();
  final _CircularProgressDrawingCache _drawingCache =
      _CircularProgressDrawingCache();

  late final _waveOffsetController = AnimationController(vsync: this);
  late final _waveOffsetTween = Tween<double>(begin: 0, end: 1);
  late final _waveOffsetAnimation = _waveOffsetTween.animate(
    _waveOffsetController,
  );
  late final _waveOffset = ValueNotifier<double>(0);

  // Amplitude ramps over 500ms: standard easing in, emphasized-accelerate
  // easing out (IncreasingAmplitudeAnimationSpec /
  // DecreasingAmplitudeAnimationSpec).
  late final _amplitudeFractionController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final _amplitudeFraction = CurvedAnimation(
    parent: _amplitudeFractionController,
    curve: _kStandardEasing,
    reverseCurve: _kEmphasizedAccelerateEasing,
  );

  late final _indeterminateController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: _kCircularAnimationProgressDurationMs,
    ),
  );

  double _currentWavelength = 0;
  double _currentWaveSpeed = 0;
  int _currentVertexCount = -1;

  double? get _effectiveValue =>
      widget.value == null ? null : clampDouble(widget.value!, 0, 1);

  bool get _isWithinWaveAnimationRange {
    final effectiveValue = _effectiveValue;
    return effectiveValue != null &&
        effectiveValue > _kFullAmplitudeProgressMin &&
        effectiveValue < _kFullAmplitudeProgressMax;
  }

  @override
  void initState() {
    super.initState();

    _waveOffsetAnimation.addListener(() {
      _waveOffset.value = _waveOffsetAnimation.value % 1;
    });

    // Compose parity: the wave keeps moving while the amplitude ramps down,
    // and the offset animation stops once the indicator is fully flat.
    _amplitudeFractionController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _waveOffsetController.stop();
      }
    });

    if (_effectiveValue == null) {
      _indeterminateController.repeat();
      _amplitudeFractionController.value = 1;
    } else {
      _amplitudeFractionController.value = _isWithinWaveAnimationRange ? 1 : 0;
    }
  }

  @override
  void didUpdateWidget(CircularWavyProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      if (_effectiveValue == null) {
        _indeterminateController
          ..reset()
          ..repeat();
      } else {
        _indeterminateController.stop();
      }
    }
  }

  @override
  void dispose() {
    _waveOffsetController.dispose();
    _waveOffset.dispose();
    _amplitudeFractionController.dispose();
    _amplitudeFraction.dispose();
    _indeterminateController.dispose();

    super.dispose();
  }

  /// Updates the wave offset and amplitude change animations, potentially
  /// starting them if they are not already running.
  ///
  /// The wave offset animation moves the pattern by one full revolution
  /// (that is, [vertexCount] wavelengths) per cycle, so its duration is
  /// `wavelength / waveSpeed * vertexCount` seconds.
  void _maybeUpdateAnimations({
    required double amplitude,
    required double wavelength,
    required double waveSpeed,
    required int vertexCount,
  }) {
    if (_currentWavelength != wavelength ||
        _currentWaveSpeed != waveSpeed ||
        _currentVertexCount != vertexCount) {
      if (waveSpeed > 0 && wavelength > 0 && vertexCount > 0) {
        // Start from current offset.
        final begin = _waveOffset.value;
        _waveOffsetTween
          ..begin = begin
          ..end = begin + 1;

        final milliseconds = math.max(
          ((wavelength / waveSpeed) * 1000 * vertexCount).round(),
          _kMinAnimationDurationMs,
        );
        _waveOffsetController
          ..duration = Duration(milliseconds: milliseconds)
          ..reset();
      } else {
        _waveOffsetController
          ..duration = null
          ..stop();
      }

      _currentWavelength = wavelength;
      _currentWaveSpeed = waveSpeed;
      _currentVertexCount = vertexCount;
    }

    if (amplitude == 0) {
      _waveOffsetController.stop();
      _amplitudeFractionController.stop();
      return;
    }

    final effectiveValue = _effectiveValue;

    if (effectiveValue == null) {
      if (!_waveOffsetController.isAnimating &&
          _waveOffsetController.duration != null) {
        _waveOffsetController.repeat();
      }
    } else {
      if (_isWithinWaveAnimationRange) {
        if (!_waveOffsetController.isAnimating &&
            _waveOffsetController.duration != null) {
          _waveOffsetController.repeat();
        }
        if (!_amplitudeFractionController.isAnimating &&
            !_amplitudeFractionController.isCompleted) {
          _amplitudeFractionController.forward();
        }
      } else {
        if (!_amplitudeFractionController.isDismissed &&
            _amplitudeFractionController.status != AnimationStatus.reverse) {
          // The wave offset keeps running until the amplitude reaches zero;
          // the status listener stops it then.
          _amplitudeFractionController.reverse();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveColor = widget.color ?? colorScheme.primary;
    final effectiveTrackColor =
        widget.trackColor ?? colorScheme.secondaryContainer;
    final effectiveStrokeWidth = widget.strokeWidth ?? _kActiveThickness;
    final effectiveTrackGap = widget.trackGap ?? _kTrackActiveSpace;
    final effectiveWavelength = widget.wavelength ?? _kActiveWaveWavelength;
    // Match to one wavelength per second by default.
    final effectiveWaveSpeed = widget.waveSpeed ?? effectiveWavelength;

    var semanticsValue = widget.semanticsValue;
    if (semanticsValue == null && _effectiveValue != null) {
      semanticsValue = '${(_effectiveValue! * 100).round()}%';
    }

    return Semantics(
      label: widget.semanticsLabel,
      value: semanticsValue,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: _kWaveContainerSize,
          minHeight: _kWaveContainerSize,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final Size size = constraints.constrain(
              const Size(_kWaveContainerSize, _kWaveContainerSize),
            );

            // Compute the wave (vertex) count the same way the shapes do:
            // 2πr / wavelength, rounded to a whole number of waves.
            final double radius =
                size.shortestSide / 2 - effectiveStrokeWidth / 2;
            final int vertexCount = math.max(
              _kMinCircularVertexCount,
              (2 * math.pi * radius / effectiveWavelength).round(),
            );

            _maybeUpdateAnimations(
              amplitude: widget.amplitude,
              wavelength: effectiveWavelength,
              waveSpeed: effectiveWaveSpeed,
              vertexCount: vertexCount,
            );

            return CustomPaint(
              size: size,
              painter: _CircularWavyProgressIndicatorPainter(
                shapes: _shapes,
                drawingCache: _drawingCache,
                value: _effectiveValue,
                indeterminateValue: _indeterminateController.view,
                color: effectiveColor,
                trackColor: effectiveTrackColor,
                strokeWidth: effectiveStrokeWidth,
                trackGap: effectiveTrackGap,
                maxAmplitude: widget.amplitude,
                amplitudeFraction: _amplitudeFraction,
                wavelength: effectiveWavelength,
                enableMotion: effectiveWaveSpeed > 0,
                waveOffset: _waveOffset,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      PercentProperty(
        'value',
        _effectiveValue,
        showName: false,
        ifNull: '<indeterminate>',
      ),
    );
  }
}

class _CircularWavyProgressIndicatorPainter extends CustomPainter {
  _CircularWavyProgressIndicatorPainter({
    required this.shapes,
    required this.drawingCache,
    required this.value,
    required this.indeterminateValue,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.trackGap,
    required this.maxAmplitude,
    required this.amplitudeFraction,
    required this.wavelength,
    required this.enableMotion,
    required this.waveOffset,
  }) : super(
         repaint: Listenable.merge([
           indeterminateValue,
           amplitudeFraction,
           waveOffset,
         ]),
       );

  // The indeterminate animations, all sharing one 6000ms cycle
  // (ProgressIndicator.kt):
  //
  // Global rotation: three full linear turns per cycle
  // (CircularGlobalRotationDegreesTarget).
  //
  // Additional rotation: an extra 90° hop every 1500ms, eased over 300ms with
  // the emphasized-decelerate curve, holding in between
  // (circularIndeterminateRotationAnimationSpec).
  static final Animatable<double> _additionalRotation = TweenSequence<double>([
    for (int i = 0; i < 4; i++) ...[
      TweenSequenceItem(
        tween: Tween<double>(
          begin: i * 90,
          end: (i + 1) * 90,
        ).chain(CurveTween(curve: _kEmphasizedDecelerateEasing)),
        weight: _kAdditionalRotationDurationMs.toDouble(),
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>((i + 1) * 90),
        weight: (_kAdditionalRotationDelayMs - _kAdditionalRotationDurationMs)
            .toDouble(),
      ),
    ],
  ]);

  // Progress sweep: expands from 10% to 87% over the first half of the cycle
  // and contracts back over the second, with the standard easing
  // (circularIndeterminateProgressAnimationSpec).
  static final Animatable<double> _progressSweep = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(
        begin: _kIndeterminateMinProgress,
        end: _kIndeterminateMaxProgress,
      ).chain(CurveTween(curve: _kStandardEasing)),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween<double>(
        begin: _kIndeterminateMaxProgress,
        end: _kIndeterminateMinProgress,
      ).chain(CurveTween(curve: _kStandardEasing)),
      weight: 1,
    ),
  ]);

  final _CircularShapes shapes;

  final _CircularProgressDrawingCache drawingCache;

  final double? value;

  final ValueListenable<double> indeterminateValue;

  final Color color;

  final Color trackColor;

  final double strokeWidth;

  final double trackGap;

  final double maxAmplitude;

  final ValueListenable<double> amplitudeFraction;

  final double wavelength;

  final bool enableMotion;

  final ValueListenable<double> waveOffset;

  Paint _strokePaint(Color color) {
    return Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double endProgress;
    double rotationDegrees = 0;

    final effectiveValue = value;

    if (effectiveValue != null) {
      endProgress = effectiveValue;
    } else {
      final double t = indeterminateValue.value;
      endProgress = _progressSweep.transform(t);
      // The +90 offset matches the Compose drawing, which rotates the
      // 12 o'clock-anchored path so the indeterminate arc leads correctly.
      rotationDegrees =
          t * _kGlobalRotationDegreesTarget +
          _additionalRotation.transform(t) +
          90;
    }

    final double amplitude = clampDouble(
      amplitudeFraction.value * maxAmplitude,
      0,
      1,
    );
    final bool motion =
        enableMotion && (effectiveValue != null || amplitude > 0);

    // A Morph is only required to render partial amplitudes; 0 renders the
    // circle polygon and 1 renders the star polygon directly.
    shapes.update(
      size: size,
      wavelength: wavelength,
      strokeWidth: strokeWidth,
      requiresMorph: amplitude > 0 && amplitude < 1,
    );

    drawingCache.updatePaths(
      size: size,
      progressPathProvider: shapes.getProgressPath,
      trackPathProvider: shapes.getTrackPath,
      enableProgressMotion: motion,
      startProgress: 0,
      endProgress: endProgress,
      amplitude: amplitude,
      waveOffset: (amplitude > 0 && motion) ? waveOffset.value : 0,
      wavelength: wavelength,
      gapSize: trackGap,
      strokeWidth: strokeWidth,
    );

    canvas.save();

    if (rotationDegrees != 0) {
      final Offset center = size.center(Offset.zero);
      canvas
        ..translate(center.dx, center.dy)
        ..rotate(rotationDegrees * math.pi / 180)
        ..translate(-center.dx, -center.dy);
    }

    // Draw the track.
    canvas.drawPath(drawingCache.trackPathToDraw, _strokePaint(trackColor));

    // Draw the progress.
    canvas.drawPath(drawingCache.progressPathToDraw, _strokePaint(color));

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CircularWavyProgressIndicatorPainter oldDelegate) {
    return oldDelegate.shapes != shapes ||
        oldDelegate.drawingCache != drawingCache ||
        oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackGap != trackGap ||
        oldDelegate.maxAmplitude != maxAmplitude ||
        oldDelegate.amplitudeFraction != amplitudeFraction ||
        oldDelegate.wavelength != wavelength ||
        oldDelegate.enableMotion != enableMotion ||
        oldDelegate.waveOffset != waveOffset;
  }
}

/// Returns and caches the [shapes.RoundedPolygon]s and the [shapes.Morph]
/// that are displayed by circular wavy progress indicators.
///
/// A port of the Compose `CircularShapes`: the track is a circle polygon and
/// the active indicator is a rounded star, both with one vertex per wave so
/// they morph smoothly into each other as the amplitude changes.
class _CircularShapes {
  Size? _currentSize;
  double _currentWavelength = -1;

  shapes.RoundedPolygon? _trackPolygon;
  shapes.RoundedPolygon? _activeIndicatorPolygon;
  shapes.Morph? _activeIndicatorMorph;

  int currentVertexCount = -1;

  /// Updates the shapes according to the size of the circular loader and its
  /// wave's wavelength and stroke width.
  void update({
    required Size size,
    required double wavelength,
    required double strokeWidth,
    required bool requiresMorph,
  }) {
    assert(wavelength > 0, 'Wavelength should be greater than zero.');

    if (size != _currentSize || wavelength != _currentWavelength) {
      // Compute the number of edges as a factor of the circle size that the
      // morph will be rendered in and its proposed wavelength
      // (2πr / wavelength), where the radius takes the stroke into account.
      final double r = size.shortestSide / 2 - strokeWidth / 2;
      final int numVertices = math.max(
        _kMinCircularVertexCount,
        (2 * math.pi * r / wavelength).round(),
      );

      if (numVertices != currentVertexCount) {
        // The vertex count matches at the track's polygon, resulting in a
        // smoother morphing between the active indicator and the track.
        _trackPolygon = shapes.RoundedPolygon.circle(
          numVertices: numVertices,
        ).normalized();
        _activeIndicatorPolygon = shapes.RoundedPolygon.star(
          numVerticesPerRadius: numVertices,
          innerRadius: 0.75,
          rounding: const shapes.CornerRounding(radius: 0.35, smoothing: 0.4),
          innerRounding: const shapes.CornerRounding(radius: 0.5),
        ).normalized();
        _activeIndicatorMorph = null;
      }

      _currentSize = size;
      _currentWavelength = wavelength;
      currentVertexCount = numVertices;
    }

    if (requiresMorph && _activeIndicatorMorph == null) {
      _activeIndicatorMorph = shapes.Morph(
        _trackPolygon!,
        _activeIndicatorPolygon!,
      );
    }
  }

  /// Returns the path for the track polygon, starting at 12 o'clock.
  Path? getTrackPath(
    double amplitude,
    double wavelength,
    double strokeWidth,
    Size size,
    Path path,
  ) {
    final trackPolygon = _trackPolygon;
    if (trackPolygon == null) return null;

    return trackPolygon.toPath(startAngle: 270, path: path);
  }

  /// Returns the path for the active indicator (i.e. the progress path),
  /// starting at 12 o'clock. In case a [shapes.Morph] was previously created
  /// at the [update], it generates the path for the given [amplitude].
  /// Otherwise, the star polygon is returned when the amplitude is 1, and the
  /// circle polygon otherwise.
  Path getProgressPath(
    double amplitude,
    double wavelength,
    double strokeWidth,
    Size size,
    bool supportsMotion,
    Path path,
  ) {
    final activeIndicatorMorph = _activeIndicatorMorph;

    if (activeIndicatorMorph != null) {
      return activeIndicatorMorph.toPath(
        progress: amplitude,
        startAngle: 270,
        repeatPath: supportsMotion,
        // The RoundedPolygons used in the Morph were normalized (i.e. moved
        // to (0.5, 0.5)).
        rotationPivotX: 0.5,
        rotationPivotY: 0.5,
        path: path,
      );
    }

    if (amplitude == 1 && _activeIndicatorPolygon != null) {
      return _activeIndicatorPolygon!.toPath(
        startAngle: 270,
        repeatPath: supportsMotion,
        path: path,
      );
    }

    return _trackPolygon!.toPath(
      startAngle: 270,
      repeatPath: supportsMotion,
      path: path,
    );
  }
}

/// A drawing cache of [Path]s and [PathMetric]s to be used when drawing
/// circular progress indicators.
///
/// A port of the Compose `CircularProgressDrawingCache`. The normalized
/// shape paths are scaled to the drawing size and centered, and the visible
/// progress and track segments are extracted from them by path length. Wave
/// motion is achieved by extracting a shifted segment from a repeated path
/// and counter-rotating it around the center.
class _CircularProgressDrawingCache {
  double _currentAmplitude = -1;
  double _currentWavelength = -1;
  Size? _currentSize;

  /// Zero to one value that represents the progress start position.
  double _currentStartProgress = -1;

  /// Zero to one value that represents the progress end position.
  double _currentEndProgress = -1;
  double _currentIndicatorTrackGapSize = -1;
  double _currentWaveOffset = -1;
  double _currentStrokeWidth = -1;
  bool _currentProgressMotionEnabled = false;

  double _progressPathLength = 0;
  double _trackPathLength = 0;

  /// The current stroke cap width.
  double _currentStrokeCapWidth = 0;

  /// A [Path] that represents the progress indicator when it's in a complete
  /// state.
  Path _fullProgressPath = Path();

  PathMetric? _progressPathMetric;
  PathMetric? _trackPathMetric;

  /// A [Path] that represents the current progress and will be used to draw
  /// it.
  Path progressPathToDraw = Path();

  /// A [Path] that represents the track and will be used to draw it.
  Path trackPathToDraw = Path();

  /// Creates or updates the progress and track paths, and caches them to
  /// avoid redundant updates before updating the draw paths according to the
  /// progress.
  void updatePaths({
    required Size size,
    required Path Function(
      double amplitude,
      double wavelength,
      double strokeWidth,
      Size size,
      bool supportsMotion,
      Path path,
    )
    progressPathProvider,
    required Path? Function(
      double amplitude,
      double wavelength,
      double strokeWidth,
      Size size,
      Path path,
    )
    trackPathProvider,
    required bool enableProgressMotion,
    required double startProgress,
    required double endProgress,
    required double amplitude,
    required double waveOffset,
    required double wavelength,
    required double gapSize,
    required double strokeWidth,
  }) {
    final forceUpdate = _updateFullPaths(
      size: size,
      progressPathProvider: progressPathProvider,
      trackPathProvider: trackPathProvider,
      enableProgressMotion: enableProgressMotion,
      amplitude: amplitude,
      wavelength: wavelength,
      gapSize: gapSize,
      strokeWidth: strokeWidth,
    );
    _updateDrawPaths(
      forceUpdate: forceUpdate,
      startProgress: startProgress,
      endProgress: endProgress,
      waveOffset: waveOffset,
    );
  }

  /// Updates the full progress and track paths and their [PathMetric]s.
  ///
  /// Returns true if the full paths were updated, or false otherwise.
  bool _updateFullPaths({
    required Size size,
    required Path Function(
      double amplitude,
      double wavelength,
      double strokeWidth,
      Size size,
      bool supportsMotion,
      Path path,
    )
    progressPathProvider,
    required Path? Function(
      double amplitude,
      double wavelength,
      double strokeWidth,
      Size size,
      Path path,
    )
    trackPathProvider,
    required bool enableProgressMotion,
    required double amplitude,
    required double wavelength,
    required double gapSize,
    required double strokeWidth,
  }) {
    if (_currentSize == size &&
        _currentAmplitude == amplitude &&
        _currentWavelength == wavelength &&
        _currentStrokeWidth == strokeWidth &&
        _currentIndicatorTrackGapSize == gapSize &&
        _currentProgressMotionEnabled == enableProgressMotion) {
      // No update required.
      return false;
    }

    // Update the stroke cap width to take into consideration when drawing
    // the path.
    _currentStrokeCapWidth = size.height > size.width ? 0 : strokeWidth / 2;

    // The shape paths are normalized to a unit square, so they are scaled to
    // the drawing size (inset by the stroke) and centered.
    final scaleMatrix = Matrix4.diagonal3Values(
      size.width - strokeWidth,
      size.height - strokeWidth,
      1,
    );

    // Note that we pass in the enableProgressMotion when generating the
    // path. This may generate a path that is double in length to support
    // offsetting the drawing, so we make sure to adjust for it when storing
    // the progressPathLength.
    _fullProgressPath = _processPath(
      progressPathProvider(
        amplitude,
        wavelength,
        strokeWidth,
        size,
        enableProgressMotion,
        Path(),
      ),
      size,
      scaleMatrix,
    );
    final progressMetric = _fullProgressPath
        .computeMetrics(forceClosed: true)
        .first;
    _progressPathMetric = progressMetric;
    _progressPathLength = enableProgressMotion
        ? progressMetric.length / 2
        : progressMetric.length;

    final trackPathForAmplitude = trackPathProvider(
      amplitude,
      wavelength,
      strokeWidth,
      size,
      Path(),
    );
    if (trackPathForAmplitude != null) {
      final fullTrackPath = _processPath(
        trackPathForAmplitude,
        size,
        scaleMatrix,
      );
      final trackMetric = fullTrackPath.computeMetrics(forceClosed: true).first;
      _trackPathMetric = trackMetric;
      _trackPathLength = trackMetric.length;
    } else {
      _trackPathMetric = null;
      _trackPathLength = 0;
    }

    // Cache the full path attributes.
    _currentSize = size;
    _currentAmplitude = amplitude;
    _currentWavelength = wavelength;
    _currentStrokeWidth = strokeWidth;
    _currentIndicatorTrackGapSize = gapSize;
    _currentProgressMotionEnabled = enableProgressMotion;

    return true;
  }

  /// Scales a given path and then centers it inside a given size.
  Path _processPath(Path path, Size size, Matrix4 scaleMatrix) {
    final scaled = path.transform(scaleMatrix.storage);
    final bounds = scaled.getBounds();
    // Translate the path to align its center with the available size center.
    return scaled.shift(size.center(Offset.zero) - bounds.center);
  }

  /// Updates and caches the draw paths by the progress and wave offset.
  ///
  /// It's important to call this function only _after_ a call for
  /// [_updateFullPaths] was made.
  void _updateDrawPaths({
    required bool forceUpdate,
    required double startProgress,
    required double endProgress,
    required double waveOffset,
  }) {
    assert(
      _currentSize != null,
      '_updateDrawPaths was called before _updateFullPaths',
    );
    if (!forceUpdate &&
        _currentStartProgress == startProgress &&
        _currentEndProgress == endProgress &&
        _currentWaveOffset == waveOffset) {
      // No update required.
      return;
    }

    final progressMetric = _progressPathMetric!;

    final pStart = startProgress * _progressPathLength;
    final pStop = endProgress * _progressPathLength;

    final trackGapSize = math.min(pStop, _currentIndicatorTrackGapSize);
    final insets = math.min(pStop, _currentStrokeCapWidth);
    final trackSpacing = insets * 2 + trackGapSize;

    // Handle offsetting the path when motion is enabled. The provided path
    // was repeated in this case, which allows extracting the segment with a
    // shift and then counter-rotating the result to create a shifted path as
    // the progress moves.
    if (_currentProgressMotionEnabled) {
      final coercedWaveOffset = clampDouble(waveOffset, 0, 1);
      final startStopShift = coercedWaveOffset * _progressPathLength;

      progressPathToDraw = progressMetric.extractPath(
        pStart + startStopShift,
        pStop + startStopShift,
      );

      final offsetAngle = (coercedWaveOffset * 360) % 360;
      if (offsetAngle != 0) {
        // Rotate the progress path around the full path's center to adjust
        // for the shift.
        final center = _fullProgressPath.getBounds().center;
        final rotationMatrix = Matrix4.identity()
          ..translateByDouble(center.dx, center.dy, 0, 1)
          ..rotateZ(-offsetAngle * math.pi / 180)
          ..translateByDouble(-center.dx, -center.dy, 0, 1);
        progressPathToDraw = progressPathToDraw.transform(
          rotationMatrix.storage,
        );
      }
    } else {
      // No motion, so just grab the segment for the start and stop.
      progressPathToDraw = progressMetric.extractPath(pStart, pStop);
    }

    if (_trackPathLength > 0) {
      final tStart = endProgress * _trackPathLength + trackSpacing;
      final tStop = _trackPathLength - trackSpacing;
      trackPathToDraw = tStop > tStart
          ? _trackPathMetric!.extractPath(tStart, tStop)
          : Path();
    } else {
      trackPathToDraw = Path();
    }

    // Cache.
    _currentStartProgress = startProgress;
    _currentEndProgress = endProgress;
    _currentWaveOffset = waveOffset;
  }
}
