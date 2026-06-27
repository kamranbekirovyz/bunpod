import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_wavy_progress_indicator/wavy_linear_progress_indicator.dart';

/// Defines the visual properties of [WavyLinearProgressIndicator] widgets.
///
/// Used by [WavyLinearProgressIndicatorTheme] to control the visual properties
/// of wavy linear progress indicators in a widget subtree.
///
/// To obtain this configuration, use [WavyLinearProgressIndicatorTheme.of] to
/// access the closest ancestor [WavyLinearProgressIndicatorTheme] of the
/// current [BuildContext].
///
/// See also:
///
///  * [WavyLinearProgressIndicatorTheme], an [InheritedWidget] that propagates
/// the theme down its subtree.
@immutable
class WavyLinearProgressIndicatorThemeData with Diagnosticable {
  /// Creates the set of properties used to configure
  /// [WavyLinearProgressIndicator] widgets.
  const WavyLinearProgressIndicatorThemeData({
    this.color,
    this.trackColor,
    this.stopIndicatorColor,
    this.strokeWidth,
    this.stopIndicatorWidth,
    this.trackGap,
    this.amplitude,
    this.wavelength,
    this.waveSpeed,
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

  /// {@macro flutter.material.WavyLinearProgressIndicator.color}
  final Color? color;

  /// {@macro flutter.material.WavyLinearProgressIndicator.trackColor}
  final Color? trackColor;

  /// {@macro flutter.material.WavyLinearProgressIndicator.stopIndicatorColor}
  final Color? stopIndicatorColor;

  /// {@macro flutter.material.WavyLinearProgressIndicator.strokeWidth}
  final double? strokeWidth;

  /// {@macro flutter.material.WavyLinearProgressIndicator.stopIndicatorWidth}
  final double? stopIndicatorWidth;

  /// {@macro flutter.material.WavyLinearProgressIndicator.trackGap}
  final double? trackGap;

  /// {@macro flutter.material.WavyLinearProgressIndicator.amplitude}
  final double? amplitude;

  /// {@macro flutter.material.WavyLinearProgressIndicator.wavelength}
  final double? wavelength;

  /// {@macro flutter.material.WavyLinearProgressIndicator.waveSpeed}
  final double? waveSpeed;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  WavyLinearProgressIndicatorThemeData copyWith({
    Color? color,
    Color? trackColor,
    Color? stopIndicatorColor,
    double? strokeWidth,
    double? stopIndicatorWidth,
    double? trackGap,
    double? amplitude,
    double? wavelength,
    double? waveSpeed,
  }) {
    return WavyLinearProgressIndicatorThemeData(
      color: color ?? this.color,
      trackColor: trackColor ?? this.trackColor,
      stopIndicatorColor: stopIndicatorColor ?? this.stopIndicatorColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      stopIndicatorWidth: stopIndicatorWidth ?? this.stopIndicatorWidth,
      trackGap: trackGap ?? this.trackGap,
      amplitude: amplitude ?? this.amplitude,
      wavelength: wavelength ?? this.wavelength,
      waveSpeed: waveSpeed ?? this.waveSpeed,
    );
  }

  /// Linearly interpolate between two loading indicator themes.
  ///
  /// If both arguments are null, then null is returned.
  static WavyLinearProgressIndicatorThemeData? lerp(
    WavyLinearProgressIndicatorThemeData? a,
    WavyLinearProgressIndicatorThemeData? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }
    return WavyLinearProgressIndicatorThemeData(
      color: Color.lerp(
        a?.color,
        b?.color,
        t,
      ),
      trackColor: Color.lerp(a?.trackColor, b?.trackColor, t),
      stopIndicatorColor: Color.lerp(
        a?.stopIndicatorColor,
        b?.stopIndicatorColor,
        t,
      ),
      strokeWidth: lerpDouble(a?.strokeWidth, b?.strokeWidth, t),
      stopIndicatorWidth: lerpDouble(
        a?.stopIndicatorWidth,
        b?.stopIndicatorWidth,
        t,
      ),
      trackGap: lerpDouble(a?.trackGap, b?.trackGap, t),
      amplitude: lerpDouble(a?.amplitude, b?.amplitude, t),
      wavelength: lerpDouble(a?.wavelength, b?.wavelength, t),
      waveSpeed: lerpDouble(a?.waveSpeed, b?.waveSpeed, t),
    );
  }

  @override
  int get hashCode => Object.hash(
    color,
    trackColor,
    stopIndicatorColor,
    strokeWidth,
    stopIndicatorWidth,
    trackGap,
    amplitude,
    wavelength,
    waveSpeed,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WavyLinearProgressIndicatorThemeData &&
        other.color == color &&
        other.trackColor == trackColor &&
        other.stopIndicatorColor == stopIndicatorColor &&
        other.strokeWidth == strokeWidth &&
        other.stopIndicatorWidth == stopIndicatorWidth &&
        other.trackGap == trackGap &&
        other.amplitude == amplitude &&
        other.wavelength == wavelength &&
        other.waveSpeed == waveSpeed;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(ColorProperty('trackColor', trackColor, defaultValue: null))
      ..add(
        ColorProperty(
          'stopIndicatorColor',
          stopIndicatorColor,
          defaultValue: null,
        ),
      )
      ..add(DoubleProperty('strokeWidth', strokeWidth, defaultValue: null))
      ..add(
        DoubleProperty(
          'stopIndicatorWidth',
          stopIndicatorWidth,
          defaultValue: null,
        ),
      )
      ..add(DoubleProperty('trackGap', trackGap, defaultValue: null))
      ..add(DoubleProperty('amplitude', amplitude, defaultValue: null))
      ..add(DoubleProperty('wavelength', wavelength, defaultValue: null))
      ..add(DoubleProperty('waveSpeed', waveSpeed, defaultValue: null));
  }
}

/// An inherited widget that defines the configuration for
/// [WavyLinearProgressIndicator]s in this widget's subtree.
///
/// Values specified here are used for [WavyLinearProgressIndicator] properties
/// that are not given an explicit non-null value.
///
/// {@tool snippet}
///
/// Here is an example of a loading indicator theme that applies a red active
/// indicator color.
///
/// ```dart
/// const WavyLinearProgressIndicatorTheme(
///   data: WavyLinearProgressIndicatorData(
///     color: Colors.red,
///   ),
///   child: WavyLinearProgressIndicator(),
/// )
/// ```
/// {@end-tool}
class WavyLinearProgressIndicatorTheme extends InheritedTheme {
  /// Creates a theme that controls the configurations for
  /// [WavyLinearProgressIndicator] widgets.
  const WavyLinearProgressIndicatorTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// The properties for descendant [WavyLinearProgressIndicator] widgets.
  final WavyLinearProgressIndicatorThemeData data;

  /// Returns the [data] from the closest [WavyLinearProgressIndicatorTheme]
  /// ancestor. If there is no ancestor, it returns null.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// WavyLinearProgressIndicatorThemeData? theme = WavyLinearProgressIndicatorTheme.of(context);
  /// ```
  static WavyLinearProgressIndicatorThemeData? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<WavyLinearProgressIndicatorTheme>()
        ?.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return WavyLinearProgressIndicatorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(WavyLinearProgressIndicatorTheme oldWidget) =>
      data != oldWidget.data;
}
