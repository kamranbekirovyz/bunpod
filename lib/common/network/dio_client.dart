import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';
import 'package:logarte/logarte.dart';

Dio buildDio() {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
    ),
  );

  dio.interceptors.add(AuthInterceptor());
  dio.interceptors.add(LogarteDioInterceptor(logarte));

  return dio;
}
