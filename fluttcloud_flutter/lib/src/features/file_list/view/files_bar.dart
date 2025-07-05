import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilesBar extends WatchingWidget {
  const FilesBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = watchIt<FileListController>();
    final currentPath = controller.currentPath;
    final fetchFiles = controller.fetchFiles;
    final fileCount = controller.files.length;
    final backBtnVisible = currentPath != '/';

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
