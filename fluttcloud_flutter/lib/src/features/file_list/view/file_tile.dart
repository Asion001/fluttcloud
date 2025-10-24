import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

class FileTile extends StatelessWidget {
  const FileTile({required this.file, super.key});
  final FsEntry file;

  IconData _getIcon() {
    return switch (file.type) {
      FsEntryType.directory => Icons.folder,
      FsEntryType.file => Icons.insert_drive_file,
      FsEntryType.symlink => Icons.link,
    };
  }

  String _formatSize(int? size) {
    if (size == null) return '';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final modifiedAt = file.updatedAt.toLocal().toString().split('.').first;
    return Card(
      child: ListTile(
        leading: Icon(_getIcon(), color: Theme.of(context).colorScheme.primary),
        title: Text(file.fullpath.split('/').last),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(file.type.name),
            if (file.size != null && file.type == FsEntryType.file)
              Text(
                _formatSize(file.size),
                style: const TextStyle(fontSize: 12),
              ),
            Text(
              '${LocaleKeys.modified.tr()}: $modifiedAt',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: file.type != FsEntryType.file
            ? null
            : IconButton(
                onPressed: () async {
                  await CreateShareLinkDialog(file: file).show(context);
                },
                icon: const Icon(Icons.share),
              ),
        isThreeLine: true,
      ),
    );
  }
}
