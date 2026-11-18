import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

Dio buildDio() {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent': AppValues.userAgent,
      },
    ),
  );

  return dio;
}
