import 'dart:async';

import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

@singleton
class FileListController extends ChangeNotifier {
  List<FsEntry> files = [];
  String currentPath = '/';
  String? errorMessage;

  Future<void> fetchFiles([String? path]) async {
    files.clear();

    final lastPath = currentPath;
    currentPath = path.isEmptyOrNull ? '/' : path ?? currentPath;
    if (currentPath.isEmptyOrNull) currentPath = '/';

    notifyListeners();

    // Allows to wait for stream completion
    final completer = Completer<void>();

    Serverpod.I.client.files
        .list(serverFolderPath: currentPath)
        .listen(
          _addFile,
          onDone: completer.complete,
          onError: (Object? error) {
            // Handle error, e.g., show a snackbar or dialog
            logger.e('Error fetching files: $error');
            ToastController.I.show(error.toString());
            completer.complete();
            currentPath = lastPath.isEmptyOrNull ? '/' : lastPath;
          },
          cancelOnError: true,
        );

    await completer.future;
  }

  void _addFile(FsEntry file) {
    // Ignore files that are not in the current path
    var parentPath = file.parentPath;
    if (parentPath.isEmptyOrNull) parentPath = '/';
    if (parentPath != currentPath) return;

    files
      ..add(file)
      ..sort((a, b) {
        return a.type == FsEntryType.directory &&
                b.type != FsEntryType.directory
            ? -1
            : a.type != FsEntryType.directory && b.type == FsEntryType.directory
            ? 1
            : a.fullpath.compareTo(b.fullpath);
      });
    notifyListeners();
  }
}
