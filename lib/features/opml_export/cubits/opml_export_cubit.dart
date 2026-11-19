import 'dart:convert';

import 'package:bunpod/bunpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpmlExportCubit extends Cubit<ViewState<int>> {
  OpmlExportCubit() : super(const ViewIdle());

  Future<void> exportAndSave(List<Channel> channels) async {
    emit(const ViewBusy());

    final Uri? saved = await FilePicker.saveFile(
      fileName: 'bunpod-subscriptions.opml',
      bytes: Uint8List.fromList(
        utf8.encode(
          OpmlWriter.write(channels),
        ),
      ),
      mimeType: 'text/x-opml',
    );

    // cancelled in the save dialog
    emit(
      saved == null
          ? const ViewIdle()
          : ViewReady(
              channels.length,
            ),
    );
  }
}
