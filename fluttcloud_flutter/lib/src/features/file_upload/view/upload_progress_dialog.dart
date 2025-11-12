import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

class UploadProgressDialog extends StatelessWidget {
  const UploadProgressDialog({super.key});

  Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        LocaleKeys.file_upload_upload_progress.tr(),
        style: context.textTheme.titleMedium,
      ),
      content: SizedBox(
        width: 500,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: const _UploadList(),
        ),
      ),
      actions: [
        Row(
          spacing: 16,
          children: [
            OutlinedButton(
              onPressed: FileUploadController.I.clearCompletedUploads,
              child: Text(LocaleKeys.file_upload_clear.tr()),
            ).expand(),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(LocaleKeys.ok.tr()),
            ).expand(),
          ],
        ),
      ],
    );
  }
}

class _UploadList extends WatchingWidget {
  const _UploadList();

  @override
  Widget build(BuildContext context) {
    final controller = watchIt<FileUploadController>();
    final tasks = controller.uploadTasks;

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_upload, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.file_upload_no_files_selected.tr(),
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _UploadTaskTile(task: task);
      },
    );
  }
}

class _UploadTaskTile extends StatelessWidget {
  const _UploadTaskTile({required this.task});

  final UploadTask task;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.fileName,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _StatusIcon(status: task.status),
                if (task.status == UploadStatus.uploading)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      FileUploadController.I.cancelUpload(task);
                    },
                    tooltip: LocaleKeys.file_upload_cancel_upload.tr(),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (task.status == UploadStatus.uploading) ...[
              LinearProgressIndicator(
                value: task.progress,
                minHeight: 8,
              ),
              const SizedBox(height: 4),
              Text(
                task.progressPercent,
                style: context.textTheme.bodySmall,
              ),
            ] else if (task.status == UploadStatus.failed) ...[
              Text(
                task.error ?? LocaleKeys.file_upload_upload_failed.tr(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.theme.colorScheme.error,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ] else if (task.status == UploadStatus.completed) ...[
              Text(
                LocaleKeys.file_upload_upload_complete.tr(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: Colors.green,
                ),
              ),
            ] else if (task.status == UploadStatus.cancelled) ...[
              Text(
                LocaleKeys.file_upload_upload_cancelled.tr(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: Colors.orange,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final UploadStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case UploadStatus.pending:
        return const Icon(Icons.schedule, size: 20, color: Colors.grey);
      case UploadStatus.uploading:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case UploadStatus.completed:
        return const Icon(Icons.check_circle, size: 20, color: Colors.green);
      case UploadStatus.failed:
        return Icon(
          Icons.error,
          size: 20,
          color: context.theme.colorScheme.error,
        );
      case UploadStatus.cancelled:
        return const Icon(Icons.cancel, size: 20, color: Colors.orange);
    }
  }
}
