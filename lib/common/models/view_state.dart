import 'package:bunpod/bunpod.dart';
import 'package:flutter/foundation.dart';

sealed class ViewState<T> {
  const ViewState();

  // Copyright: aljan.me
  static Future<ViewState<T>> guard<T>(
    Future<T> Function() future, {
    ViewState<T> Function(T result)? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      final result = await future();

      if (onSuccess != null) {
        return onSuccess(result);
      }

      return ViewReady<T>(result);
    } catch (error, stackTrace) {
      onError?.call();

      logarte.log('error: $error');
      logarte.log('stack trace: $stackTrace');

      return ViewFailed<T>();
    }
  }
}

final class ViewIdle<T> extends ViewState<T> {
  const ViewIdle();
}

final class ViewBusy<T> extends ViewState<T> {
  const ViewBusy();
}

final class ViewReady<T> extends ViewState<T> {
  final T? data;

  const ViewReady([this.data]);
}

final class ViewFailed<T> extends ViewState<T> {
  final String? error;

  const ViewFailed([this.error]);
}
