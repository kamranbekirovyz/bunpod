import 'package:haptic_feedback/haptic_feedback.dart';

class HapticsHelper {
  HapticsHelper._();

  static bool? _canVibrate;

  static Future<void> _vibrate(HapticsType type) async {
    _canVibrate ??= await Haptics.canVibrate();

    if (_canVibrate ?? false) {
      await Haptics.vibrate(type);
    }
  }

  static Future<void> success() => _vibrate(.success);
  static Future<void> warning() => _vibrate(.warning);
  static Future<void> error() => _vibrate(.error);
  static Future<void> light() => _vibrate(.light);
  static Future<void> medium() => _vibrate(.medium);
  static Future<void> heavy() => _vibrate(.heavy);
  static Future<void> selection() => _vibrate(.selection);
}
