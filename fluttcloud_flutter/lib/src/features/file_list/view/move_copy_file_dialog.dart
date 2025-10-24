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
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  String _selectedFolder = '/';
  final List<FsEntry> _folders = [];
  bool _isLoadingFolders = true;

  @override
  void initState() {
    super.initState();
    final fileName = widget.file.fullpath.split('/').last;
    _nameController = TextEditingController(text: fileName);
    _loadFolders();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadFolders() async {
    setState(() {
      _isLoadingFolders = true;
    });

    try {
      final stream = Serverpod.I.client.files.list(
        serverFolderPath: '/',
        filterByType: FsEntryType.directory,
      );
      await for (final entry in stream) {
        _folders.add(entry);
      }
      if (mounted) {
        setState(() {
          _isLoadingFolders = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingFolders = false;
        });
      }
    }
  }

  Future<void> _loadSubfolders(String path) async {
    try {
      final stream = Serverpod.I.client.files.list(
        serverFolderPath: path,
        filterByType: FsEntryType.directory,
      );
      final newFolders = <FsEntry>[];
      await for (final entry in stream) {
        newFolders.add(entry);
      }
      if (mounted) {
        setState(() {
          _folders.addAll(newFolders);
        });
      }
    } catch (e) {
      // Ignore errors
    }
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
                    ? LocaleKeys.file_actions_move_description.tr(
                        args: [fileName],
                      )
                    : LocaleKeys.file_actions_copy_description.tr(
                        args: [fileName],
                      ),
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.file_actions_destination_path.tr(),
                style: context.textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              if (_isLoadingFolders)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  initialValue: _selectedFolder,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: '/',
                      child: Text('/'),
                    ),
                    ..._folders.map((folder) {
                      return DropdownMenuItem<String>(
                        value: folder.serverFullpath,
                        child: Text(folder.serverFullpath),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFolder = value ?? '/';
                    });
                    if (value != null && value != '/') {
                      _loadSubfolders(value);
                    }
                  },
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
              ),
              const SizedBox(height: 8),
              Text(
                '${LocaleKeys.file_actions_destination.tr()}: '
                '$_selectedFolder/${_nameController.text}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
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
              onPressed: _isProcessing
                  ? null
                  : () => Navigator.of(context).pop(false),
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
      final fileName = _nameController.text.trim();
      final destinationPath = '$_selectedFolder/$fileName';
      final controller = getIt<FileListController>();

      if (widget.operationType == FileOperationType.move) {
        await controller.moveFile(widget.file, destinationPath);
      } else {
        await controller.copyFile(widget.file, destinationPath);
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
