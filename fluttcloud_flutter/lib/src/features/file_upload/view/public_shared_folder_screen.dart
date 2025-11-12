import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PublicSharedFolderScreen extends StatefulWidget {
  const PublicSharedFolderScreen({
    super.key,
    @QueryParam('linkPrefix') required this.linkPrefix,
  });

  final String linkPrefix;

  @override
  State<PublicSharedFolderScreen> createState() =>
      _PublicSharedFolderScreenState();
}

class _PublicSharedFolderScreenState extends State<PublicSharedFolderScreen> {
  SharedLink? _sharedLink;
  List<FsEntry> _files = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLinkInfo();
  }

  Future<void> _loadLinkInfo() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get link info
      final linkInfo = await Serverpod.I.client.links.getPublicLinkInfo(
        widget.linkPrefix,
      );

      if (linkInfo == null) {
        setState(() {
          _error = LocaleKeys.share_links.tr();
          _isLoading = false;
        });
        return;
      }

      // Check if upload is allowed
      if (!linkInfo.canUpload) {
        setState(() {
          _error = 'This link does not allow uploads';
          _isLoading = false;
        });
        return;
      }

      // Load files
      final files = <FsEntry>[];
      await for (final entry
          in Serverpod.I.client.files.listPublic(linkPrefix: widget.linkPrefix)) {
        files.add(entry);
      }

      setState(() {
        _sharedLink = linkInfo;
        _files = files;
        _isLoading = false;
      });
    } catch (e) {
      logger.e('Error loading public shared folder: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadFiles() async {
    // TODO: Implement public file upload
    await ToastController.I.show(
      'Public upload not yet implemented in UI',
      type: ToastType.info,
    );
  }

  void Function()? _getOnTapFunc(BuildContext context, FsEntry file) {
    // For public folders, we can only show a message since we don't have full navigation
    return switch (file.type) {
      FsEntryType.directory => () {
          ToastController.I.show(
            'Directory navigation not supported in public view',
            type: ToastType.info,
          );
        },
      FsEntryType.file => () {
          ToastController.I.show(
            'File preview not available in public view',
            type: ToastType.info,
          );
        },
      FsEntryType.symlink => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.file_upload_title.tr()),
        actions: [
          if (_sharedLink != null && _sharedLink!.canUpload)
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: _uploadFiles,
              tooltip: LocaleKeys.file_upload_upload.tr(),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: context.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _loadLinkInfo,
                        child: Text(LocaleKeys.retry.tr()),
                      ),
                    ],
                  ).paddingAll(16),
                )
              : _files.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.folder_open,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            LocaleKeys.file_upload_no_files_in_folder.tr(),
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _files.length,
                      itemBuilder: (context, index) {
                        final file = _files[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _getOnTapFunc(context, file),
                          child: FileTile(file: file),
                        ).paddingSymmetric(horizontal: 8, vertical: 2);
                      },
                    ),
    );
  }
}
