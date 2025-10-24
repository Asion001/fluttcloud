import 'dart:async';

import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

enum FileAction {
  rename,
  copy,
  move,
  delete,
}

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

  Future<void> deleteFile(FsEntry file) async {
    await Serverpod.I.client.files.deleteFile(file.serverFullpath);
    await ToastController.I.show(LocaleKeys.file_actions_deleted.tr());
    await fetchFiles(useCache: false);
  }

  Future<void> renameFile(FsEntry file, String newName) async {
    await Serverpod.I.client.files.renameFile(file.serverFullpath, newName);
    await ToastController.I.show(LocaleKeys.file_actions_renamed.tr());
    await fetchFiles(useCache: false);
  }

  Future<void> copyFile(FsEntry file, String destinationPath) async {
    await Serverpod.I.client.files.copyFile(
      file.serverFullpath,
      destinationPath,
    );
    await ToastController.I.show(LocaleKeys.file_actions_copied.tr());
    await fetchFiles(useCache: false);
  }

  Future<void> moveFile(FsEntry file, String destinationPath) async {
    await Serverpod.I.client.files.moveFile(
      file.serverFullpath,
      destinationPath,
    );
    await ToastController.I.show(LocaleKeys.file_actions_moved.tr());
    await fetchFiles(useCache: false);
  }
}
