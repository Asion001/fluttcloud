import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FilePreview extends StatefulWidget {
  const FilePreview({required this.file, super.key});
  final FsEntry file;

  Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  State<FilePreview> createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> {
  bool _isFullscreen = false;

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  void _downloadFile() {
    final uri = Uri.parse(widget.file.privateShareUrl);
    FileDownloadController.I.downloadFile(uri.getDownloadUri());
  }

  Future<void> _showFileInfo() =>
      FileInfoDialog(file: widget.file).show(context);

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(widget.file.privateShareUrl);

    return Dialog(
      insetPadding: _isFullscreen ? EdgeInsets.zero : const EdgeInsets.all(40),
      constraints: _isFullscreen
          ? const BoxConstraints()
          : const BoxConstraints(maxWidth: 600, maxHeight: 800),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                path.basename(widget.file.serverFullpath),
                style: context.textTheme.titleLarge,
              ).flexible(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    tooltip: LocaleKeys.info.tr(),
                    onPressed: _showFileInfo,
                  ),
                  IconButton(
                    icon: const Icon(Icons.download),
                    tooltip: LocaleKeys.download.tr(),
                    onPressed: _downloadFile,
                  ),
                  IconButton(
                    icon: Icon(
                      _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    ),
                    tooltip: _isFullscreen
                        ? LocaleKeys.exit_fullscreen.tr()
                        : LocaleKeys.fullscreen.tr(),
                    onPressed: _toggleFullscreen,
                  ),
                  const CloseButton(),
                ],
              ),
            ],
          ).paddingLeft(16),
          switch (widget.file.contentType) {
            FsEntryContentType.image => ImagePreview(uri: uri),
            FsEntryContentType.text => TextPreview(uri: uri),
            FsEntryContentType.video => MediaPreview(uri: uri),
            FsEntryContentType.audio => MediaPreview(uri: uri),
            _ => _JustDownloadFile(uri: uri),
          }.flexible(),
        ],
      ).paddingAll(8),
    );
  }
}

class _JustDownloadFile extends StatelessWidget {
  const _JustDownloadFile({required this.uri});
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(LocaleKeys.file_type_not_supported.tr()),
        FilledButton(
          onPressed: () {
            FileDownloadController.I.downloadFile(uri.getDownloadUri());
            Navigator.of(context).pop();
          },
          child: Text(LocaleKeys.download.tr()),
        ),
      ],
    );
  }
}
