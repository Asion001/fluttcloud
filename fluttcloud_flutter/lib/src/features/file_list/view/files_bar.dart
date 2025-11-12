import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:fluttcloud_flutter/src/features/file_upload/controllers/file_upload_controller.dart';
import 'package:fluttcloud_flutter/src/features/file_upload/view/upload_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilesBar extends WatchingWidget {
  const FilesBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = watchIt<FileListController>();
    final uploadController = watchIt<FileUploadController>();
    final currentPath = controller.currentPath;
    final fetchFiles = controller.fetchFiles;
    final fileCount = controller.files.length;
    final backBtnVisible = currentPath != '/';
    final hasActiveUploads = uploadController.hasActiveUploads;
    final activeUploadCount = uploadController.activeUploadCount;

    return Row(
      children: [
        Visibility.maintain(
          visible: backBtnVisible,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: !backBtnVisible
                ? null
                : () {
                    final path = currentPath == '/'
                        ? null
                        : currentPath
                              .split('/')
                              .sublist(0, currentPath.split('/').length - 1)
                              .join('/');
                    fetchFiles(path: path);
                  },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => fetchFiles(useCache: false),
        ),
        IconButton(
          icon: const Icon(Icons.upload_file),
          onPressed: () async {
            await FileUploadController.I.pickAndUploadFiles(currentPath);
          },
          tooltip: LocaleKeys.file_upload_upload.tr(),
        ),
        if (hasActiveUploads)
          Badge(
            label: Text('$activeUploadCount'),
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => UploadProgressDialog.show(context),
              tooltip: LocaleKeys.file_upload_view_progress.tr(),
            ),
          ),
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: currentPath));
            ToastController.I.show(
              LocaleKeys.copied_to_clipboard.tr(args: [currentPath]),
              type: ToastType.info,
            );
          },
          child: Text(
            currentPath,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ).paddingSymmetric(horizontal: 16),
        ).expand(),
        Text(LocaleKeys.items.plural(fileCount)),
      ],
    ).paddingRight(16);
  }
}
