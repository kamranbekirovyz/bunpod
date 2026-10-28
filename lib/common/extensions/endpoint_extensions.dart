import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

extension EndpointExtensions on Endpoint {
  Future<Response<T>> send<T>() {
    return locator<Dio>().request<T>(
      url,
      data: body,
      queryParameters: query,
      options: Options(method: method),
    );
  }
}
