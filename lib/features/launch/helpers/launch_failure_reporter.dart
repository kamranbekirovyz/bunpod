import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Tells us when the app could not start, as a critical alert.
abstract final class LaunchFailureReporter {
  static const Duration _timeout = Duration(seconds: 10);

  static const int _maxLength = 4096;

  static Future<void> report({
    required Object error,
    required StackTrace stackTrace,
  }) async {
    try {
      await _send(error, stackTrace).timeout(_timeout);
    } catch (_) {
      // A failure here must not hide the screen.
    }
  }

  static Future<void> _send(Object error, StackTrace stackTrace) async {
    final String message =
        '🚨 BunPod failed to launch\n'
        'Platform: ${defaultTargetPlatform.name}\n'
        'Mode: ${kReleaseMode ? 'release' : 'debug'}\n\n'
        '$error\n\n'
        '$stackTrace';

    await Dio().post<void>(
      'https://api.telegram.org/bot${AppConfig.telegramBotToken}/sendMessage',
      data: {
        'chat_id': AppConfig.telegramChatId,
        'text': message.length > _maxLength
            ? message.substring(0, _maxLength)
            : message,
      },
    );
  }
}
