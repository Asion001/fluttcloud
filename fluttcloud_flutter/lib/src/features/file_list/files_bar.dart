import 'dart:async';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

class FilesBar extends StatelessWidget {
  const FilesBar({
    required this.currentPath,
    required this.fetchFiles,
    super.key,
  });
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
