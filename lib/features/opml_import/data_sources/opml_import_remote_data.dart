import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class OpmlImportRemoteData {
  const OpmlImportRemoteData();

  Future<OpmlImport> import({
    required List<int> bytes,
    required String fileName,
  }) async {
    final Response<Map<String, dynamic>> response =
        await RestfulEndpoints.importOpml(
          bytes: bytes,
          fileName: fileName,
        ).send<Map<String, dynamic>>();

    return OpmlImport.fromJson(response.data!);
  }
}
