import 'dart:async';

import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:fluttcloud_flutter/src/features/file_list/file_tile.dart';
import 'package:fluttcloud_flutter/src/features/file_list/files_bar.dart';
import 'package:flutter/material.dart';

class FileList extends StatefulWidget {
  const FileList({super.key});

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  List<FsEntry> files = [];
  String? currentPath;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFiles();
  }

  Future<void> _fetchFiles([String? path]) async {
    files.clear();
    final lastPath = currentPath;
    currentPath = path ?? currentPath;

    setState(() {});

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
            currentPath = lastPath.isEmptyOrNull ? null : lastPath;
          },
          cancelOnError: true,
        );

    await completer.future;
  }

  void _addFile(FsEntry file) {
    setState(() {
      files
        ..add(file)
        ..sort((a, b) {
          return a.type == FsEntryType.directory &&
                  b.type != FsEntryType.directory
              ? -1
              : a.type != FsEntryType.directory &&
                    b.type == FsEntryType.directory
              ? 1
              : a.fullpath.compareTo(b.fullpath);
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            FilesBar(currentPath: currentPath, fetchFiles: _fetchFiles),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ).paddingAll(8).center()
            else
              RefreshIndicator(
                onRefresh: _fetchFiles,
                child: ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];

                    return InkWell(
                      borderRadius: 16.circular,
                      onTap: _getOnTapFunc(file),
                      child: FileTile(file: file),
                    ).paddingSymmetric(horizontal: 8, vertical: 2);
                  },
                ),
              ).expand(),
          ],
        ).expand(),
      ],
    );
  }

  void Function()? _getOnTapFunc(FsEntry file) {
    return switch (file.type) {
      FsEntryType.directory => () => _fetchFiles(file.serverFullpath),
      FsEntryType.file => () => FilePreview(file: file).show(context),
      FsEntryType.symlink => null,
    };
  }
}
