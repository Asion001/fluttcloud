import 'dart:async';

import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

@singleton
class FileListController extends ChangeNotifier {
  final List<FsEntry> files = [];
  String currentPath = '/';
  String? errorMessage;

  Future<void> fetchFiles({bool useCache = true, String? path}) async {
    files.clear();

    final lastPath = currentPath;
    currentPath = path ?? currentPath;
    if (currentPath.isEmptyOrNull) currentPath = '/';

    notifyListeners();

    final cachedFiles = _cachedFiles[currentPath];
    if (useCache && cachedFiles != null) {
      files.addAll(cachedFiles);
      _sortFiles();
      notifyListeners();
    }

    final stream = Serverpod.I.client.files.list(
      serverFolderPath: currentPath,
    );

    final tmpFiles = <FsEntry>[];

    final sub = _listenToStream(
      stream: stream,
      lastPath: lastPath,
      onData: (fsEntry) {
        // If useCache is true, add to tmpFiles and then update files
        // If useCache is false, add directly to files one by one
        tmpFiles.add(fsEntry);
        if (!useCache || cachedFiles == null) {
          _addFile(fsEntry);
        }
      },
    );

    await sub.asFuture<void>();
    try {
      await sub.cancel();
    } catch (_) {}

    if (useCache) {
      files
        ..clear()
        ..addAll(tmpFiles);
      _sortFiles();
      notifyListeners();
    }

    _cachedFiles[lastPath] = List<FsEntry>.from(files);
  }

  StreamSubscription<FsEntry> _listenToStream({
    required Stream<FsEntry> stream,
    required String lastPath,
    required void Function(FsEntry) onData,
  }) {
    return stream.listen(
      onData,
      onError: (Object? error) {
        // Handle error, e.g., show a snackbar or dialog
        logger.e('Error fetching files: $error');
        ToastController.I.show(error.toString());
        currentPath = lastPath.isEmptyOrNull ? '/' : lastPath;
      },
      cancelOnError: true,
    );
  }

  void _addFile(FsEntry file) {
    // Ignore files that are not in the current path
    var parentPath = file.parentPath;
    if (parentPath.isEmptyOrNull) parentPath = '/';
    if (parentPath != currentPath) return;

    files.add(file);
    _sortFiles();
    notifyListeners();
  }

  void _sortFiles() {
    files.sort((a, b) {
      return a.type == FsEntryType.directory && b.type != FsEntryType.directory
          ? -1
          : a.type != FsEntryType.directory && b.type == FsEntryType.directory
          ? 1
          : a.fullpath.compareTo(b.fullpath);
    });
  }

  final Map<String, List<FsEntry>> _cachedFiles = {};
}
