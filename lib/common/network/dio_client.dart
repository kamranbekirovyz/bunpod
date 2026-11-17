import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';
import 'package:logarte/logarte.dart';

Dio buildDio() {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'User-Agent': AppValues.userAgent},
    ),
  );

  dio.interceptors.add(LogarteDioInterceptor(logarte));

  return dio;
}
