import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

/// Adds the access token and clears tokens on 401.
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? accessToken =
        await locator<SecureStorageLocalData>().accessToken;

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await locator<SecureStorageLocalData>().clearTokens();
    }

    handler.next(err);
  }
}
