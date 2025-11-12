import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

class FileInfoDialog extends StatelessWidget {
  const FileInfoDialog({required this.file, super.key});
  final FsEntry file;

  Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => this,
    );
  }

  String _formatSize(int? size) {
    if (size == null) return '-';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.info.tr()),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            _InfoRow(
              label: LocaleKeys.file.tr(),
              value: file.fullpath.split('/').last,
            ),
            _InfoRow(
              label: LocaleKeys.content_type.tr(),
              value: file.contentType.name,
            ),
            if (file.size != null)
              _InfoRow(
                label: LocaleKeys.size.tr(),
                value: _formatSize(file.size),
              ),
            _InfoRow(
              label: LocaleKeys.created.tr(),
              value: _formatDateTime(file.createdAt),
            ),
            _InfoRow(
              label: LocaleKeys.modified.tr(),
              value: _formatDateTime(file.updatedAt),
            ),
            _InfoRow(
              label: LocaleKeys.path.tr(),
              value: file.fullpath,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(LocaleKeys.ok.tr()),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
