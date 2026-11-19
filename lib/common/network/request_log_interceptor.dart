import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class RequestLogInterceptor extends Interceptor {
  static const String _startedAt = 'startedAt';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAt] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log(response.requestOptions, '${response.statusCode}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(
      err.requestOptions,
      '${err.response?.statusCode ?? err.type.name}',
      failed: true,
    );
    handler.next(err);
  }

  void _log(RequestOptions options, String status, {bool failed = false}) {
    final DateTime? startedAt = options.extra[_startedAt];
    final int ms = startedAt == null
        ? 0
        : DateTime.now().difference(startedAt).inMilliseconds;
    final Uri uri = options.uri;

    final String emoji = failed
        ? '❌'
        : switch (uri.host) {
            final String host when host.contains('podcastindex') => '🎙️',
            final String host when host.contains('apple') => '🍎',
            _ => '📡',
          };

    logarte.log(
      '$emoji ${options.method} ${uri.host}${uri.path} · $status · $ms ms',
    );
  }
}
