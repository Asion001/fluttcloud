import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

class FileList extends WatchingWidget {
  const FileList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = watchIt<FileListController>();
    final errorMessage = controller.errorMessage;
    final files = controller.files;

    callOnce((context) => controller.fetchFiles());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            if (errorMessage != null)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ).paddingAll(8).center()
            else
              RefreshIndicator(
                onRefresh: controller.fetchFiles,
                child: ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];

                    return InkWell(
                      borderRadius: 16.circular,
                      onTap: _getOnTapFunc(context, file),
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

  void Function()? _getOnTapFunc(BuildContext context, FsEntry file) {
    return switch (file.type) {
      FsEntryType.directory => () => getIt<FileListController>().fetchFiles(
        file.serverFullpath,
      ),
      FsEntryType.file => () => FilePreview(file: file).show(context),
      FsEntryType.symlink => null,
    };
  }
}
