import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:material_wavy_progress_indicator/wavy_linear_progress_indicator_theme.dart';

const double _kFullAmplitudeProgressMin = 0.1;
const double _kFullAmplitudeProgressMax = 0.9;

const int _kIndeterminateDurationMilliseconds = 1800;

// The progress value below which the track gap is scaled proportionally to
// prevent a track gap from appearing at 0% progress.
const double _kTrackGapRampDownThreshold = 0.01;

/// A Material Design wavy linear progress indicator, also known as a progress
/// bar.
///
/// A widget that shows progress along a line. There are two kinds of linear
/// progress indicators:
///
///  * _Determinate_. Determinate progress indicators have a specific value at
///    each point in time, and the value should increase monotonically from 0.0
///    to 1.0, at which time the indicator is complete. To create a determinate
///    progress indicator, use a non-null [value] between 0.0 and 1.0.
///  * _Indeterminate_. Indeterminate progress indicators do not have a specific
///    value at each point in time and instead indicate that progress is being
///    made without indicating how much progress remains. To create an
///    indeterminate progress indicator, use a null [value].
class WavyLinearProgressIndicator extends StatefulWidget {
  /// Creates a Material Design wavy linear progress indicator.
  const WavyLinearProgressIndicator({
    this.value,
    this.color,
    this.trackColor,
    this.stopIndicatorColor,
    this.strokeWidth,
    this.stopIndicatorWidth,
    this.trackGap,
    this.amplitude,
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
         stopIndicatorWidth == null || stopIndicatorWidth > 0,
         'stopIndicatorWidth has to be greater than zero.',
       ),
       assert(
         trackGap == null || trackGap >= 0,
         'trackGap must not be negative.',
       ),
       assert(
         amplitude == null || amplitude >= 0,
         'amplitude must not be negative.',
       ),
       assert(
         wavelength == null || wavelength > 0,
         'wavelength has to be greater than zero.',
       ),
       assert(
         waveSpeed == null || waveSpeed >= 0,
         'waveSpeed must not be negative.',
       );

  /// {@template flutter.material.WavyLinearProgressIndicator.value}
  /// The value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range [0.0 - 1.0].
  ///
  /// If null, this progress indicator is indeterminate, which means the
  /// indicator displays a predetermined animation that does not indicate how
  /// much actual progress is being made.
  /// {@endtemplate}
  final double? value;

  /// {@template flutter.material.WavyLinearProgressIndicator.color}
  /// The color of the [WavyLinearProgressIndicator]'s active indicator.
  /// {@endtemplate}
  ///
  /// If null, then the [WavyLinearProgressIndicatorThemeData.color] will be used.
  /// If that is null, then the [ColorScheme.primary] will be used.
  final Color? color;

  /// {@template flutter.material.WavyLinearProgressIndicator.trackColor}
  /// The color of the [WavyLinearProgressIndicator]'s track.
  /// {@endtemplate}
  ///
  /// If null, then the [WavyLinearProgressIndicatorThemeData.trackColor]
  /// will be used.
  /// If that is null, then the [ColorScheme.secondaryContainer] will be used.
  final Color? trackColor;

  /// {@template flutter.material.WavyLinearProgressIndicator.stopIndicatorColor}
  /// The color of the [WavyLinearProgressIndicator]'s stop indicator.
  /// {@endtemplate}
  ///
  /// If null, then the [WavyLinearProgressIndicatorThemeData.stopIndicatorColor]
  /// will be used.
  /// If that is null, then the [ColorScheme.primary] will be used.
  final Color? stopIndicatorColor;

  /// {@template flutter.material.WavyLinearProgressIndicator.strokeWidth}
  /// The width of the active indicator and track.
  /// {@endtemplate}
  ///
  /// If null, then the [WavyLinearProgressIndicatorThemeData.strokeWidth] will
  /// be used.
  /// If that is null, then defaults to 4.
  final double? strokeWidth;

  /// {@template flutter.material.WavyLinearProgressIndicator.stopIndicatorWidth}
  /// The width of the stop indicator.
  /// {@endtemplate}
  ///
  /// If null, then the [WavyLinearProgressIndicatorThemeData.stopIndicatorWidth]
  /// will be used.
  /// If that is null, then defaults to 4.
  final double? stopIndicatorWidth;

  /// {@template flutter.material.WavyLinearProgressIndicator.trackGap}
  /// The size of the gap between active indicator and track.
  /// {@endtemplate}
  ///
  /// If null, then the [WavyLinearProgressIndicatorThemeData.trackGap] will be
  /// used.
  /// If that is null, then defaults to 4.
  final double? trackGap;

  /// {@template flutter.material.WavyLinearProgressIndicator.amplitude}
  /// The amplitude of the active indicator wave.
  /// {@endtemplate}
  ///
  /// If null, then the [WavyLinearProgressIndicatorThemeData.amplitude] will
  /// be used.
  /// If that is null, then defaults to 3.
  final double? amplitude;

  /// {@template flutter.material.WavyLinearProgressIndicator.wavelength}
  /// The wavelength (distance between between two adjacent peaks) of the
  /// active indicator wave.
  /// {@endtemplate}
  ///
  /// If null, then the [WavyLinearProgressIndicatorThemeData.wavelength] will
  /// be used.
  /// If that is null, then defaults to 40 for determinate indicator and 20 for
  /// indeterminate.
  final double? wavelength;

  /// {@template flutter.material.WavyLinearProgressIndicator.waveSpeed}
  /// The speed of the active indicator wave in logical pixels per second.
  /// {@endtemplate}
  ///
  /// If null, then the [WavyLinearProgressIndicatorThemeData.waveSpeed] will
  /// be used.
  /// If that is null, then defaults to 40 for determinate indicator and 20 for
  /// indeterminate.
  final double? waveSpeed;

  /// {@template flutter.material.WavyLinearProgressIndicator.semanticsLabel}
  /// The [SemanticsProperties.label] for this progress indicator.
  ///
  /// This value indicates the purpose of the progress bar, and will be
  /// read out by screen readers to indicate the purpose of this progress
  /// indicator.
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@template flutter.material.WavyLinearProgressIndicator.semanticsValue}
  /// The [SemanticsProperties.value] for this progress indicator.
  ///
  /// This will be used in conjunction with the [semanticsLabel] by
  /// screen reading software to identify the widget, and is primarily
  /// intended for use with determinate progress indicators to announce
  /// how far along they are.
  ///
  /// For determinate progress indicators, this will be defaulted to
  /// [ProgressIndicator.value] expressed as a percentage, i.e. `0.1` will
  /// become `10%`.
  /// {@endtemplate}
  final String? semanticsValue;

  @override
  State<WavyLinearProgressIndicator> createState() =>
      _WavyLinearProgressIndicatorState();
}

class _WavyLinearProgressIndicatorState
    extends State<WavyLinearProgressIndicator>
    with TickerProviderStateMixin {
  final _drawingCache = _WavyLinearProgressIndicatorDrawingCache();

  late final _waveOffsetController = AnimationController(vsync: this);
  late final _waveOffsetTween = Tween<double>(begin: 0, end: 1);
  late final _waveOffsetAnimation = _waveOffsetTween.animate(
    _waveOffsetController,
  );
  late final _waveOffset = ValueNotifier<double>(0);

  late final _amplitudeFractionController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final _amplitudeFraction = CurvedAnimation(
    parent: _amplitudeFractionController,
    curve: const Cubic(0.2, 0, 0, 1),
    reverseCurve: const Cubic(0.3, 0, 0.8, 0.15),
  );

  late final _indeterminateValueController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: _kIndeterminateDurationMilliseconds),
  );

  double _currentWavelength = 0;

  double _currentWaveSpeed = 0;

  double? get _effectiveValue =>
      widget.value == null ? null : clampDouble(widget.value!, 0, 1);

  bool get _isWithinWaveAnimationRange {
    final effectiveValue = _effectiveValue;
    return effectiveValue != null &&
        effectiveValue >= _kFullAmplitudeProgressMin &&
        effectiveValue <= _kFullAmplitudeProgressMax;
  }

  @override
  void initState() {
    super.initState();

    _waveOffsetAnimation.addListener(() {
      _waveOffset.value = _waveOffsetAnimation.value % 1;
    });

    final effectiveValue = _effectiveValue;

    if (effectiveValue == null) {
      _indeterminateValueController.repeat();
      _amplitudeFractionController.value = 1;
    } else {
      if (_isWithinWaveAnimationRange) {
        _amplitudeFractionController.value = 1;
      } else {
        _amplitudeFractionController.value = 0;
      }
    }
  }

  @override
  void didUpdateWidget(WavyLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      final effectiveValue = _effectiveValue;

      if (effectiveValue == null) {
        _indeterminateValueController
          ..reset()
          ..repeat();
        _amplitudeFractionController.forward();
      } else {
        _indeterminateValueController.stop();

        if (_isWithinWaveAnimationRange) {
          _amplitudeFractionController.forward();
        } else {
          _amplitudeFractionController.reverse();
        }
      }
    }
  }

  @override
  void dispose() {
    _waveOffsetController.dispose();
    _waveOffset.dispose();
    _amplitudeFractionController.dispose();
    _amplitudeFraction.dispose();
    _indeterminateValueController.dispose();

    super.dispose();
  }

  /// Updates the wave offset and amplitude change animations, potentially
  /// starting them if they are not already running.
  void _maybeUpdateAnimations({
    required double amplitude,
    required double wavelength,
    required double waveSpeed,
  }) {
    if (_currentWavelength != wavelength || _currentWaveSpeed != waveSpeed) {
      if (waveSpeed > 0 && wavelength > 0) {
        // Start from current offset.
        final begin = _waveOffset.value;
        _waveOffsetTween
          ..begin = begin
          ..end = begin + 1;

        final milliseconds = math
            .max((wavelength / waveSpeed) * 1000, 50)
            .toInt();
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
        if (!_amplitudeFractionController.isAnimating) {
          _amplitudeFractionController.forward();
        }
      } else {
        _waveOffsetController.stop();
        if (!_amplitudeFractionController.isDismissed) {
          _amplitudeFractionController.reverse();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    late final indicatorTheme = WavyLinearProgressIndicatorTheme.of(context);
    late final defaults = _effectiveValue == null
        ? _WavyLinearProgressIndicatorIndeterminateDefaults(context)
        : _WavyLinearProgressIndicatorDeterminateDefaults(context);

    final effectiveColor =
        widget.color ?? indicatorTheme?.color ?? defaults.color;
    final effectiveTrackColor =
        widget.trackColor ?? indicatorTheme?.trackColor ?? defaults.trackColor;
    final effectiveStopIndicatorColor =
        widget.stopIndicatorColor ??
        indicatorTheme?.stopIndicatorColor ??
        defaults.stopIndicatorColor;
    final effectiveStrokeWidth =
        widget.strokeWidth ??
        indicatorTheme?.strokeWidth ??
        defaults.strokeWidth;
    final effectiveStopIndicatorWidth =
        widget.stopIndicatorWidth ??
        indicatorTheme?.stopIndicatorWidth ??
        defaults.stopIndicatorWidth;
    final effectiveTrackGap =
        widget.trackGap ?? indicatorTheme?.trackGap ?? defaults.trackGap;
    final effectiveAmplitude =
        widget.amplitude ?? indicatorTheme?.amplitude ?? defaults.amplitude;
    final effectiveWavelength =
        widget.wavelength ?? indicatorTheme?.wavelength ?? defaults.wavelength;
    final effectiveWaveSpeed =
        widget.waveSpeed ?? indicatorTheme?.waveSpeed ?? defaults.waveSpeed;

    _maybeUpdateAnimations(
      amplitude: effectiveAmplitude,
      wavelength: effectiveWavelength,
      waveSpeed: effectiveWaveSpeed,
    );

    var semanticsValue = widget.semanticsValue;
    if (semanticsValue == null && _effectiveValue != null) {
      semanticsValue = '${(_effectiveValue! * 100).round()}%';
    }

    return Semantics(
      label: widget.semanticsLabel,
      value: semanticsValue,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: effectiveAmplitude * 2 + effectiveStrokeWidth,
        ),
        child: CustomPaint(
          painter: _WavyLinearProgressIndicatorPainter(
            cache: _drawingCache,
            value: _effectiveValue,
            indeterminateValue: _indeterminateValueController.view,
            color: effectiveColor,
            trackColor: effectiveTrackColor,
            stopIndicatorColor: effectiveStopIndicatorColor,
            strokeWidth: effectiveStrokeWidth,
            stopIndicatorWidth: effectiveStopIndicatorWidth,
            trackGap: effectiveTrackGap,
            amplitude: effectiveAmplitude,
            amplitudeFraction: _amplitudeFraction,
            wavelength: effectiveWavelength,
            waveOffset: _waveOffset,
            textDirection: Directionality.of(context),
          ),
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

class _WavyLinearProgressIndicatorDeterminateDefaults
    extends WavyLinearProgressIndicatorThemeData {
  _WavyLinearProgressIndicatorDeterminateDefaults(this.context);

  final BuildContext context;

  late final _colorScheme = Theme.of(context).colorScheme;

  @override
  Color get color => _colorScheme.primary;

  @override
  Color get trackColor => _colorScheme.secondaryContainer;

  @override
  Color get stopIndicatorColor => _colorScheme.primary;

  @override
  double get strokeWidth => 4;

  @override
  double get stopIndicatorWidth => 4;

  @override
  double get trackGap => 4;

  @override
  double get amplitude => 3;

  @override
  double get wavelength => 40;

  @override
  double get waveSpeed => 40;
}

class _WavyLinearProgressIndicatorIndeterminateDefaults
    extends _WavyLinearProgressIndicatorDeterminateDefaults {
  _WavyLinearProgressIndicatorIndeterminateDefaults(super.context);

  @override
  double get wavelength => 20;

  @override
  double get waveSpeed => 20;
}

class _WavyLinearProgressIndicatorPainter extends CustomPainter {
  _WavyLinearProgressIndicatorPainter({
    required this.cache,
    required this.value,
    required this.indeterminateValue,
    required this.color,
    required this.trackColor,
    required this.stopIndicatorColor,
    required this.strokeWidth,
    required this.stopIndicatorWidth,
    required this.trackGap,
    required this.amplitude,
    required this.amplitudeFraction,
    required this.wavelength,
    required this.waveOffset,
    required this.textDirection,
  }) : super(
         repaint: Listenable.merge([
           indeterminateValue,
           amplitudeFraction,
           waveOffset,
         ]),
       );

  // The indeterminate progress animation displays two lines whose leading
  // (head) and trailing (tail) endpoints are defined by the following four
  // curves.
  static const _firstLineHead = Interval(
    0,
    750 / _kIndeterminateDurationMilliseconds,
    curve: Cubic(0.2, 0, 0.8, 1),
  );
  static const _firstLineTail = Interval(
    333 / _kIndeterminateDurationMilliseconds,
    (333 + 850) / _kIndeterminateDurationMilliseconds,
    curve: Cubic(0.4, 0, 1, 1),
  );
  static const Curve _secondLineHead = Interval(
    1000 / _kIndeterminateDurationMilliseconds,
    (1000 + 567) / _kIndeterminateDurationMilliseconds,
    curve: Cubic(0, 0, 0.65, 1),
  );
  static const Curve _secondLineTail = Interval(
    1267 / _kIndeterminateDurationMilliseconds,
    (1267 + 533) / _kIndeterminateDurationMilliseconds,
    curve: Cubic(0.1, 0, 0.45, 1),
  );

  final _WavyLinearProgressIndicatorDrawingCache cache;

  final double? value;

  final ValueListenable<double> indeterminateValue;

  final Color color;

  final Color trackColor;

  final Color stopIndicatorColor;

  final double strokeWidth;

  final double stopIndicatorWidth;

  final double trackGap;

  final double amplitude;

  final ValueListenable<double> amplitudeFraction;

  final double wavelength;

  final ValueListenable<double> waveOffset;

  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final effectiveValue = value;
    final isDeterminate = effectiveValue != null;

    final List<double> progressFractions;

    if (isDeterminate) {
      progressFractions = [0, effectiveValue];
    } else {
      final effectiveIndeterminateValue = indeterminateValue.value;
      progressFractions = [
        _firstLineTail.transform(effectiveIndeterminateValue),
        _firstLineHead.transform(effectiveIndeterminateValue),
        _secondLineTail.transform(effectiveIndeterminateValue),
        _secondLineHead.transform(effectiveIndeterminateValue),
      ];
    }

    cache.updatePaths(
      size: size,
      wavelength: wavelength,
      progressFractions: progressFractions,
      amplitude: amplitude,
      amplitudeFraction: amplitudeFraction.value,
      waveOffset: waveOffset.value,
      trackGap: trackGap,
      strokeWidth: strokeWidth,
    );

    final isRTL = textDirection == TextDirection.rtl;

    if (isRTL) {
      canvas
        ..save()
        ..translate(size.width, 0)
        ..scale(-1, 1);
    }

    // Draw track.
    canvas.drawPath(
      cache.trackPathToDraw,
      Paint()
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..color = trackColor,
    );

    // Draw a stop indicator.
    if (isDeterminate && value != 1) {
      // Limit the stop indicator radius to the strokeWidth of the indicator.
      final maxRadius = strokeWidth / 2;
      final radius = math.min(stopIndicatorWidth / 2, maxRadius);
      final position = Offset(size.width - maxRadius, size.height / 2);
      canvas.drawCircle(
        position,
        radius,
        Paint()..color = stopIndicatorColor,
      );
    }

    // Draw the progress.
    final progressPaths = cache.progressPathsToDraw;
    if (progressPaths != null) {
      for (final path in progressPaths) {
        canvas.drawPath(
          path,
          Paint()
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke
            ..color = color,
        );
      }
    }

    if (isRTL) {
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_WavyLinearProgressIndicatorPainter oldDelegate) {
    return oldDelegate.cache != cache ||
        oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.stopIndicatorColor != stopIndicatorColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.stopIndicatorWidth != stopIndicatorWidth ||
        oldDelegate.trackGap != trackGap ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.amplitudeFraction != amplitudeFraction ||
        oldDelegate.wavelength != wavelength ||
        oldDelegate.waveOffset != waveOffset ||
        oldDelegate.textDirection != textDirection;
  }
}

/// A drawing cache of [Path]s and [PathMetric] to be used when drawing linear
/// progress indicators.
class _WavyLinearProgressIndicatorDrawingCache {
  var _currentWavelength = -1.0;

  var _currentAmplitude = -1.0;

  var _currentAmplitudeFraction = -1.0;

  var _currentSize = const Size(-1, -1);

  List<double>? _currentProgressFractions;

  var _currentTrackGap = 0.0;

  var _currentWaveOffset = -1.0;

  var _currentStrokeWidth = 0.0;

  /// The current stroke cap width.
  var _currentStrokeCapWidth = 0.0;

  /// This scale value is used to grab segments from the [_pathMetric] in the
  /// correct length. It holds a value that is the result of dividing the
  /// [PathMetric] length by the actual [Path] width (in pixels) that it's
  /// holding.
  /// When the amplitude is zero and the line is flat, the scale would be 1.
  /// However, when the amplitude is greater than zero, the path is wavy and its
  /// measured length in the [PathMetric] would be longer than its measured
  /// width on screen, so  the scale would be greater than 1.
  var _progressPathScale = 1.0;

  /// A [Path] that represents the progress indicator when it's in a complete
  /// state. A drawing path can be computed from it and cached in this class
  /// with the use of [_pathMetric].
  var _fullProgressPath = Path();

  /// A [PathMetric] that will be used when computing a segment of a progress
  /// to be drawn.
  PathMetric? _pathMetric;

  /// A [Path] that represents the track and will be used to draw it.
  final trackPathToDraw = Path();

  /// A [Path] that represents the current progress and will be used to draw
  /// it. This path is derived from the [_fullProgressPath] and should be
  /// computed and cached here using the [_pathMetric].
  List<Path>? progressPathsToDraw;

  /// Creates or updates the progress path, and caches it to avoid redundant
  /// updates before updating the draw paths according to the progress.
  ///
  /// [progressFractions] is an array that holds the progress information for
  /// one or two progress segments that should be rendered on the indicator.
  /// Each value in the array represents a fractional progress location in
  /// [0.0, 1.0] range, and a pair of values represent the start and end of a
  /// progress segment.
  void updatePaths({
    required Size size,
    required double wavelength,
    required List<double> progressFractions,
    required double amplitude,
    required double amplitudeFraction,
    required double waveOffset,
    required double trackGap,
    required double strokeWidth,
  }) {
    assert(wavelength >= 0, 'wavelength must not be negative.');
    assert(
      progressFractions.length == 2 || progressFractions.length == 4,
      'progressFractions has to have a length of 2 for a determinate indicator '
      'or 4 for an indeterminate.',
    );
    assert(amplitude >= 0, 'amplitude must not be negative.');
    assert(
      amplitudeFraction >= 0 && amplitudeFraction <= 1,
      'amplitudeFraction has to be in range [0, 1].',
    );
    assert(
      waveOffset >= 0 && waveOffset <= 1,
      'waveOffset has to be in range [0, 1].',
    );
    assert(trackGap >= 0, 'trackGap must not be negative.');
    assert(strokeWidth > 0, 'strokeWidth has to be greater than zero.');

    if (_currentProgressFractions == null ||
        _currentProgressFractions!.length != progressFractions.length) {
      _currentProgressFractions = List<double>.filled(
        progressFractions.length,
        0,
      );
      progressPathsToDraw = List<Path>.generate(
        progressFractions.length ~/ 2,
        (_) => Path(),
      );
    }
    final forceUpdateDrawPaths = _updateFullPaths(
      size: size,
      amplitude: amplitude,
      wavelength: wavelength,
      trackGap: trackGap,
      strokeWidth: strokeWidth,
    );
    _updateDrawPaths(
      forceUpdate: forceUpdateDrawPaths,
      progressFractions: progressFractions,
      amplitudeFraction: amplitudeFraction,
      waveOffset: waveOffset,
    );
  }

  /// Creates or updates the progress path, and caches it to avoid redundant
  /// updates. The created path represents the progress indicator when it's in
  /// a complete state.
  ///
  /// Call this function before calling [_updateDrawPaths], which will cut
  /// segments of the full path for drawing using the internal [_pathMetric]
  /// that this function updates.
  ///
  /// Returns true if the full paths were updated, or false otherwise.
  bool _updateFullPaths({
    required Size size,
    required double wavelength,
    required double amplitude,
    required double trackGap,
    required double strokeWidth,
  }) {
    assert(wavelength >= 0, 'wavelength must not be negative.');
    assert(amplitude >= 0, 'amplitude must not be negative.');
    assert(trackGap >= 0, 'trackGap must not be negative.');
    assert(strokeWidth > 0, 'strokeWidth has to be greater than zero.');

    if (_currentSize == size &&
        _currentWavelength == wavelength &&
        _currentAmplitude == amplitude &&
        _currentTrackGap == trackGap &&
        _currentStrokeWidth == strokeWidth) {
      // No update required
      return false;
    }

    final height = size.height;
    final width = size.width;

    // Update the stroke width to take into consideration when drawing the
    // Path.
    _currentStrokeCapWidth = strokeWidth / 2;

    // There are changes that should update the full path.
    _fullProgressPath
      ..reset()
      ..moveTo(0, 0);

    if (amplitude == 0) {
      // Just a line in this case, so we can optimize with a simple lineTo call.
      _fullProgressPath.lineTo(width + wavelength * 2, 0);
    } else {
      final halfWavelengthPx = wavelength / 2;
      var anchorX = halfWavelengthPx;
      const anchorY = 0.0;
      var controlX = halfWavelengthPx / 2;

      // We set the amplitude to the max available height to create a sine-like
      // path that will later be Y-scaled on draw.
      // Note that with quadratic plotting, the height of the control point,
      // when perpendicular to the center point between the anchors, will plot
      // a wave that peaks at half the height.
      // We offset this height with the progress stroke's width to avoid
      // cropping the drawing later.
      var controlY = height - strokeWidth;

      // Plot a path that holds a couple of extra waves. This can later be used
      // to create a progressPathToDraw with a wave offset value to simulate a
      // wave movement.
      // Note that we add more than one wave-length to support cases where the
      // wavelength is relatively large and may end up in cases where a single
      // extra wavelength is not sufficient for the wave's motion drawing.
      final widthWithExtraPhase = width + wavelength * 2;

      while (anchorX <= widthWithExtraPhase) {
        _fullProgressPath.quadraticBezierTo(
          controlX,
          controlY,
          anchorX,
          anchorY,
        );
        anchorX += halfWavelengthPx;
        controlX += halfWavelengthPx;
        controlY *= -1;
      }
    }

    _fullProgressPath = _fullProgressPath.transform(
      Matrix4.translationValues(0, height / 2, 0).storage,
    );

    // Update the PathMeasure with the full path
    _pathMetric = _fullProgressPath.computeMetrics().first;

    // Calculate the progressPathScale by dividing the length of the path that
    // the PathMeasure holds by its actual width in pixels. We will use this
    // scale value later when grabbing segments from the pathMeasure.
    final fullPathLength = _pathMetric!.length;
    _progressPathScale =
        fullPathLength /
        math.max(_fullProgressPath.getBounds().width, double.minPositive);

    // Cache the full path attributes (note that the amplitude is intentionally
    // not cached here, and will be cached on the updateDrawPaths call).
    _currentSize = size;
    _currentWavelength = wavelength;
    _currentAmplitude = amplitude;
    _currentTrackGap = trackGap;
    _currentStrokeWidth = strokeWidth;

    return true;
  }

  /// Updates and caches the draw paths by to the progress, amplitude, and wave
  /// offset.
  ///
  /// It's important to call this function only after a call for
  /// [_updateFullPaths] was made.
  ///
  /// [forceUpdate] forces an update to the drawing paths. This flag will be set
  /// to true when the [_updateFullPaths] returns true to indicate that the base
  /// paths were updated.
  void _updateDrawPaths({
    required bool forceUpdate,
    required List<double> progressFractions,
    required double amplitudeFraction,
    required double waveOffset,
  }) {
    assert(
      progressFractions.length == 2 || progressFractions.length == 4,
      'progressFractions has to have a length of 2 for a determinate indicator '
      'or 4 for an indeterminate.',
    );
    assert(
      amplitudeFraction >= 0 && amplitudeFraction <= 1,
      'amplitudeFraction has to be in range [0, 1].',
    );
    assert(
      waveOffset >= 0 && waveOffset <= 1,
      'waveOffset has to be in range [0, 1].',
    );

    assert(
      _currentSize != const Size(-1, -1),
      '_updateDrawPaths was called before _updateFullPaths',
    );
    assert(
      progressPathsToDraw != null,
      '_updateDrawPaths was called before _updateFullPaths',
    );
    assert(
      progressPathsToDraw!.length == progressFractions.length / 2,
      'the given progress fraction pairs do not match the expected number of '
      'progress paths to draw. updateDrawPaths called with '
      '${progressFractions.length / 2} pairs, while there are '
      '${progressPathsToDraw!.length} expected progress paths.',
    );
    assert(
      _pathMetric != null,
      '_updateDrawPaths was called before _updateFullPaths',
    );

    if (!forceUpdate &&
        listEquals(_currentProgressFractions, progressFractions) &&
        _currentAmplitudeFraction == amplitudeFraction &&
        _currentWaveOffset == waveOffset) {
      // No update required.
      return;
    }

    final width = _currentSize.width;
    final halfHeight = _currentSize.height / 2;

    final strokeWidth = _currentStrokeCapWidth;
    final trackGapFraction = _currentTrackGap / width;
    final waveShift = waveOffset * _currentWavelength;

    final waveTransform = Matrix4.identity()
      ..translateByDouble(
        waveShift > 0 ? -waveShift : 0,
        (1 - amplitudeFraction) * halfHeight,
        0,
        1,
      );

    // The progressPathToDraw is a segment of the full progress path,
    // which is always in the maximum possible amplitude. This scaling
    // will flatten the wave to the given amplitude percentage.
    if (amplitudeFraction != 1) {
      waveTransform.scaleByDouble(1, amplitudeFraction, 1, 1);
    }

    // Calculates a track gap fraction that is scaled proportionally to a given
    // value.
    // This is used to smoothly transition the track gap's size, preventing it
    // from appearing or disappearing abruptly. The returned value increases
    // linearly from 0 to the full `trackGapFraction` as `currentValue`
    // increases from 0 to `_kTrackGapRampDownThreshold`.
    double getEffectiveTrackGapFraction(
      double currentValue,
      double trackGapFraction,
    ) {
      return trackGapFraction *
          clampDouble(currentValue, 0, _kTrackGapRampDownThreshold) /
          _kTrackGapRampDownThreshold;
    }

    // Adds track to the `trackPathsToDraw`.
    void addTrack({
      required Path trackPathsToDraw,
      required double tailFraction,
      required double headFraction,
    }) {
      final tail = tailFraction * width + strokeWidth;
      final head = headFraction * width - strokeWidth;

      if (tail > head) {
        return;
      }

      trackPathsToDraw
        ..moveTo(tail, halfHeight)
        ..lineTo(head, halfHeight);
    }

    // Updates the path on the `index` position in `progressPathsToDraw`.
    void updateProgressPath({
      required int index,
      required double tailFraction,
      required double headFraction,
    }) {
      final tail = tailFraction * width + strokeWidth;
      final head = headFraction * width - strokeWidth;

      if (tail > head) {
        return;
      }

      final path = _pathMetric!.extractPath(
        (tail + waveShift) * _progressPathScale,
        (head + waveShift) * _progressPathScale,
      );

      // Translate and scale the draw path by the wave shift and the
      // amplitude.
      progressPathsToDraw![index] = path.transform(waveTransform.storage);
    }

    // Reset previously set paths.
    for (final path in progressPathsToDraw!) {
      path.reset();
    }
    trackPathToDraw.reset();

    if (progressFractions.length == 2) {
      // Determinate progress indicator.
      final strokeWidthFraction = strokeWidth / width;
      final effectiveValue = progressFractions[1];

      // Track.
      if (effectiveValue < 1) {
        final tailFraction = effectiveValue > 0
            ? math.max(
                effectiveValue +
                    getEffectiveTrackGapFraction(
                      effectiveValue,
                      trackGapFraction,
                    ),
                strokeWidthFraction * 2,
              )
            : 0.0;
        addTrack(
          trackPathsToDraw: trackPathToDraw,
          tailFraction: tailFraction,
          headFraction: 1,
        );
      }

      // Active indicator.
      if (effectiveValue > 0) {
        final headFraction = math.max(effectiveValue, strokeWidthFraction * 2);

        updateProgressPath(
          index: 0,
          tailFraction: 0,
          headFraction: headFraction,
        );
      }
    } else {
      // Indeterminate progress indicator.
      final firstLineTail = progressFractions[0];
      final firstLineHead = progressFractions[1];
      final secondLineTail = progressFractions[2];
      final secondLineHead = progressFractions[3];

      // Track before line 1.
      if (firstLineHead < 1 - trackGapFraction) {
        final tailFraction = firstLineHead > 0
            ? firstLineHead +
                  getEffectiveTrackGapFraction(firstLineHead, trackGapFraction)
            : 0.0;
        addTrack(
          trackPathsToDraw: trackPathToDraw,
          tailFraction: tailFraction,
          headFraction: 1,
        );
      }

      // Line 1.
      if (firstLineHead - firstLineTail > 0) {
        updateProgressPath(
          index: 0,
          tailFraction: firstLineTail,
          headFraction: firstLineHead,
        );
      }

      // Track between line 1 and line 2.
      if (firstLineTail > trackGapFraction) {
        final tailFraction = secondLineHead > 0
            ? secondLineHead +
                  getEffectiveTrackGapFraction(secondLineHead, trackGapFraction)
            : 0.0;
        final headFraction = firstLineTail < 1
            ? firstLineTail -
                  getEffectiveTrackGapFraction(
                    1 - firstLineTail,
                    trackGapFraction,
                  )
            : 1.0;
        addTrack(
          trackPathsToDraw: trackPathToDraw,
          tailFraction: tailFraction,
          headFraction: headFraction,
        );
      }

      // Line 2.
      if (secondLineHead - secondLineTail > 0) {
        updateProgressPath(
          index: 1,
          tailFraction: secondLineTail,
          headFraction: secondLineHead,
        );
      }

      // Track after line 2.
      if (secondLineTail > trackGapFraction) {
        final headFraction = secondLineTail < 1
            ? secondLineTail -
                  getEffectiveTrackGapFraction(
                    1 - secondLineTail,
                    trackGapFraction,
                  )
            : 1.0;
        addTrack(
          trackPathsToDraw: trackPathToDraw,
          tailFraction: 0,
          headFraction: headFraction,
        );
      }
    }

    // Cache.
    _currentProgressFractions = progressFractions;
    _currentAmplitudeFraction = amplitudeFraction;
    _currentWaveOffset = waveOffset;
  }
}
