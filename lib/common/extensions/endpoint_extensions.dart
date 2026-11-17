import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

extension EndpointExtensions on Endpoint {
  Future<Response<T>> send<T>({
    ResponseType? responseType,
    ValidateStatus? validateStatus,
  }) {
    return locator<Dio>().get<T>(
      url,
      queryParameters: query,
      options: Options(
        headers: headers,
        responseType: responseType,
        validateStatus: validateStatus,
      ),
    );
  }
}
