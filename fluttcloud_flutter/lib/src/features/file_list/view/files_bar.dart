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

    return Row(
      children: [
        Visibility.maintain(
          visible: currentPath != '/',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final path = currentPath == '/'
                  ? null
                  : currentPath
                        .split('/')
                        .sublist(0, currentPath.split('/').length - 1)
                        .join('/');
              fetchFiles(path);
            },
          ),
        ),
        IconButton(icon: const Icon(Icons.refresh), onPressed: fetchFiles),
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
          ).paddingSymmetric(horizontal: 16),
        ),
        const Spacer(),
        Text(LocaleKeys.items.plural(fileCount)),
      ],
    ).paddingRight(16);
  }
}
