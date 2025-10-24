import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

enum FileOperationType {
  move,
  copy,
}

class MoveCopyFileDialog extends StatefulWidget {
  const MoveCopyFileDialog({
    required this.file,
    required this.operationType,
    super.key,
  });

  final FsEntry file;
  final FileOperationType operationType;

  Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  State<MoveCopyFileDialog> createState() => _MoveCopyFileDialogState();
}

class _MoveCopyFileDialogState extends State<MoveCopyFileDialog> {
  late final TextEditingController _pathController;
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final fileName = widget.file.fullpath.split('/').last;
    _pathController = TextEditingController(text: '/$fileName');
  }

  @override
  void dispose() {
    _pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.file.fullpath.split('/').last;
    final isMove = widget.operationType == FileOperationType.move;

    return AlertDialog(
      title: Text(
        isMove
            ? LocaleKeys.file_actions_move_title.tr()
            : LocaleKeys.file_actions_copy_title.tr(),
        style: context.textTheme.titleMedium,
      ),
      insetPadding: 16.all,
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMove
                    ? LocaleKeys.file_actions_move_description
                        .tr(args: [fileName])
                    : LocaleKeys.file_actions_copy_description
                        .tr(args: [fileName]),
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pathController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.file_actions_destination_path.tr(),
                  border: const OutlineInputBorder(),
                  helperText:
                      'Example: /path/to/destination/$fileName',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.file_actions_path_required.tr();
                  }
                  return null;
                },
                autofocus: true,
                maxLines: 2,
                minLines: 1,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          spacing: 16,
          children: [
            OutlinedButton(
              onPressed:
                  _isProcessing ? null : () => Navigator.of(context).pop(false),
              child: Text(LocaleKeys.cancel.tr()),
            ).expand(),
            FilledButton(
              onPressed: _isProcessing ? null : _performOperation,
              child: _isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      isMove
                          ? LocaleKeys.file_actions_move.tr()
                          : LocaleKeys.file_actions_copy.tr(),
                    ),
            ).expand(),
          ],
        ),
      ],
    );
  }

  Future<void> _performOperation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final destinationPath = _pathController.text.trim();
      
      if (widget.operationType == FileOperationType.move) {
        await Serverpod.I.client.files.moveFile(
          widget.file.serverFullpath,
          destinationPath,
        );
        await ToastController.I.show(LocaleKeys.file_actions_moved.tr());
      } else {
        await Serverpod.I.client.files.copyFile(
          widget.file.serverFullpath,
          destinationPath,
        );
        await ToastController.I.show(LocaleKeys.file_actions_copied.tr());
      }
      
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      await ToastController.I.show(e.toString());
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}
