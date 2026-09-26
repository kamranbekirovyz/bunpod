import 'package:bunpod/bunpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versionarte/versionarte.dart';

class VersionarteCubit extends Cubit<VersionarteResult?> {
  VersionarteCubit() : super(null);

  Future<void> check() async {
    final VersionarteResult result = await Versionarte.check(
      versionarteProvider: locator<VersionarteProvider>(),
    );

    emit(result);
  }

  Future<void> openStore() async {
    final Map<TargetPlatform, String?>? urls = state!.downloadUrls;

    if (urls == null) return;

    await Versionarte.launchDownloadUrl(urls);
  }
}
