import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class ProfileRemoteData {
  const ProfileRemoteData();

  Future<User> me() async {
    final Response<Map<String, dynamic>> response = await RestfulEndpoints.me()
        .send<Map<String, dynamic>>();

    return User.fromJson(response.data!);
  }
}
