import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FilePreview extends StatelessWidget {
  const FilePreview({required this.file, super.key});
  final FsEntry file;

  Future<void> show(BuildContext context) async {
    await showDialog<void>(context: context, builder: (context) => this);
  }

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(file.privateShareUrl);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  basename(file.serverFullpath),
                  style: context.textTheme.titleLarge,
                ).flexible(),
                const CloseButton(),
              ],
            ).paddingLeft(16),
            switch (file.contentType) {
              FsEntryContentType.image => ImagePreview(uri: uri),
              FsEntryContentType.text => TextPreview(uri: uri),
              FsEntryContentType.video => MediaPreview(uri: uri),
              FsEntryContentType.audio => MediaPreview(uri: uri),
              _ => _JustDownloadFile(uri: uri),
            }.flexible(),
          ],
        ).paddingAll(8),
      ),
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
            FileDownloadController.I.downloadFile(
              uri.replace(
                queryParameters: {
                  ...uri.queryParameters,
                  'download': '1',
                },
              ),
            );
            Navigator.of(context).pop();
          },
          child: Text(LocaleKeys.download.tr()),
        ),
      ],
    );
  }
}
