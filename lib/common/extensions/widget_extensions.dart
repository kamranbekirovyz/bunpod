import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

extension WidgetX on Widget {
  Route<T> asAdaptiveSheetRoute<T>({bool dismissible = true}) {
    if (defaultTargetPlatform == .iOS) {
      return StupidSimpleGlassSheetRoute<T>(
        child: this,
        blurBehindBarrier: false,
        draggable: dismissible,
      );
    }

    return StupidSimpleSheetRoute<T>(
      child: this,
      draggable: dismissible,
      barrierDismissible: dismissible,
    );
  }
}
