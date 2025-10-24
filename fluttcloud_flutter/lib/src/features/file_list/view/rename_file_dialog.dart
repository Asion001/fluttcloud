import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

class RenameFileDialog extends StatefulWidget {
  const RenameFileDialog({
    required this.file,
    super.key,
  });

  final FsEntry file;

  Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  State<RenameFileDialog> createState() => _RenameFileDialogState();
}

class _RenameFileDialogState extends State<RenameFileDialog> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final currentName = widget.file.fullpath.split('/').last;
    _nameController = TextEditingController(text: currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.file.fullpath.split('/').last;

    return AlertDialog(
      title: Text(
        LocaleKeys.file_actions_rename_title.tr(),
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
                LocaleKeys.file_actions_rename_description
                    .tr(args: [fileName]),
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.file_actions_new_name.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.file_actions_name_required.tr();
                  }
                  return null;
                },
                autofocus: true,
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
              onPressed: _isProcessing ? null : _renameFile,
              child: _isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(LocaleKeys.file_actions_rename.tr()),
            ).expand(),
          ],
        ),
      ],
    );
  }

  Future<void> _renameFile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await Serverpod.I.client.files.renameFile(
        widget.file.serverFullpath,
        _nameController.text.trim(),
      );
      await ToastController.I.show(LocaleKeys.file_actions_renamed.tr());
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
