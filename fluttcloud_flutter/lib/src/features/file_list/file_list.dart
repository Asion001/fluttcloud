import 'dart:async';

import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
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
            _FilesBar(currentPath: currentPath, fetchFiles: _fetchFiles),
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
                      onTap: file.type == FsEntryType.directory
                          ? () => _fetchFiles(file.serverFullpath)
                          : null,
                      child: _FileTile(file: file),
                    ).paddingSymmetric(horizontal: 8, vertical: 2);
                  },
                ),
              ).expand(),
          ],
        ).expand(),
      ],
    );
  }
}

class _FileTile extends StatelessWidget {
  const _FileTile({required this.file});
  final FsEntry file;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(file.fullpath.split('/').last),
        subtitle: Text(file.type.name),
      ),
    );
  }
}

class _FilesBar extends StatelessWidget {
  const _FilesBar({required this.currentPath, required this.fetchFiles});
  final String? currentPath;
  final Future<void> Function([String? path]) fetchFiles;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility.maintain(
          visible: currentPath != '/' && currentPath != null,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final path = currentPath == '/'
                  ? null
                  : currentPath!
                        .split('/')
                        .sublist(0, currentPath!.split('/').length - 1)
                        .join('/');
              fetchFiles(path);
            },
          ),
        ),
        IconButton(icon: const Icon(Icons.refresh), onPressed: fetchFiles),
        Text(
          currentPath ?? '/',
          style: Theme.of(context).textTheme.bodyMedium,
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }
}
