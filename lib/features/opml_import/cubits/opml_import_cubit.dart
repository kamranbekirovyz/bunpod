import 'package:bunpod/bunpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpmlImportCubit extends Cubit<ViewState<OpmlImport>> {
  OpmlImportCubit() : super(const ViewIdle());

  Future<void> pickAndImport() async {
    final List<PlatformFile> files = await FilePicker.pickFiles(
      // android has no opml mime type
      type: .any,
    );

    if (files.isEmpty) return;

    emit(const ViewBusy());

    emit(
      await ViewState.guard(() async {
        return locator<OpmlImportRemoteData>().import(
          bytes: await files.first.readAsBytes(),
          fileName: files.first.name,
        );
      }),
    );
  }
}
