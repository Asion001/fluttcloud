import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:fluttcloud_flutter/src/features/file_list/view/move_copy_file_dialog.dart';
import 'package:fluttcloud_flutter/src/features/file_list/view/rename_file_dialog.dart';
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (file.type == FsEntryType.file)
              IconButton(
                onPressed: () async {
                  await CreateShareLinkDialog(file: file).show(context);
                },
                icon: const Icon(Icons.share),
              ),
            PopupMenuButton<FileAction>(
              icon: const Icon(Icons.more_vert),
              tooltip: LocaleKeys.file_actions_actions.tr(),
              onSelected: (value) => _handleMenuAction(context, value),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: FileAction.rename,
                  child: Row(
                    children: [
                      const Icon(Icons.edit),
                      const SizedBox(width: 8),
                      Text(LocaleKeys.file_actions_rename.tr()),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: FileAction.copy,
                  child: Row(
                    children: [
                      const Icon(Icons.copy),
                      const SizedBox(width: 8),
                      Text(LocaleKeys.file_actions_copy.tr()),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: FileAction.move,
                  child: Row(
                    children: [
                      const Icon(Icons.drive_file_move),
                      const SizedBox(width: 8),
                      Text(LocaleKeys.file_actions_move.tr()),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: FileAction.delete,
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.delete.tr(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    FileAction action,
  ) async {
    final fileName = file.fullpath.split('/').last;
    final controller = getIt<FileListController>();

    switch (action) {
      case FileAction.rename:
        await RenameFileDialog(file: file).show(context);
      case FileAction.copy:
        await MoveCopyFileDialog(
          file: file,
          operationType: FileOperationType.copy,
        ).show(context);
      case FileAction.move:
        await MoveCopyFileDialog(
          file: file,
          operationType: FileOperationType.move,
        ).show(context);
      case FileAction.delete:
        final confirmed = await ConfirmDialog(
          title: LocaleKeys.file_actions_delete_confirm.tr(args: [fileName]),
        ).show(context);
        if (confirmed) {
          try {
            await controller.deleteFile(file);
          } catch (e) {
            await ToastController.I.show(e.toString());
          }
        }
    }
  }
}
