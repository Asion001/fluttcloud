import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PublicSharedFolderScreen extends StatefulWidget {
  const PublicSharedFolderScreen({
    super.key,
    @QueryParam('linkPrefix') this.linkPrefix,
  });

  final String? linkPrefix;

  @override
  State<PublicSharedFolderScreen> createState() =>
      _PublicSharedFolderScreenState();
}

class _PublicSharedFolderScreenState extends State<PublicSharedFolderScreen> {
  SharedLink? _sharedLink;
  final List<FsEntry> _files = [];
  bool _isLoading = true;
  String? _error;
  String _currentSubPath = ''; // Track subdirectory within shared folder

  @override
  void initState() {
    super.initState();
    _loadLinkInfo();
  }

  Future<void> _loadLinkInfo() async {
    if (widget.linkPrefix.isEmptyOrNull) {
      setState(() {
        _isLoading = false;
        _error = LocaleKeys.something_went_wrong.tr();
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get link info only on first load
      if (_sharedLink == null) {
        final linkInfo = await Serverpod.I.client.links.getPublicLinkInfo(
          widget.linkPrefix!,
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
            _error = LocaleKeys.file_upload_upload_not_allowed.tr();
            _isLoading = false;
          });
          return;
        }

        _sharedLink = linkInfo;
      }

      setState(_files.clear);

      // Load files
      await for (final entry in Serverpod.I.client.files.listPublic(
        linkPrefix: widget.linkPrefix!,
        subPath: _currentSubPath.isEmpty ? null : _currentSubPath,
      )) {
        setState(() {
          _files.add(entry);
        });
      }

      setState(() {
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

  void Function()? _getOnTapFunc(BuildContext context, FsEntry file) {
    return switch (file.type) {
      FsEntryType.directory => () => _navigateToDirectory(file),
      FsEntryType.file => () => FilePreview(file: file).show(context),
      FsEntryType.symlink => null,
    };
  }

  void _navigateToDirectory(FsEntry directory) {
    final relativePath = directory.serverFullpath
        .replaceFirst(_sharedLink!.serverPath, '')
        .replaceFirst(RegExp('^/'), '');

    setState(() {
      _currentSubPath = relativePath;
    });
    _loadLinkInfo();
  }

  void _navigateUp() {
    if (_currentSubPath.isEmpty) return;

    final segments = _currentSubPath.split('/');
    setState(() {
      _currentSubPath = segments.length > 1
          ? segments.sublist(0, segments.length - 1).join('/')
          : '';
    });
    _loadLinkInfo();
  }

  @override
  Widget build(BuildContext context) {
    final canNavigateUp = _currentSubPath.isNotEmpty;
    final displayPath = _currentSubPath.isEmpty ? '/' : '/$_currentSubPath';

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.file_upload_title.tr()),
        actions: [
          if (canNavigateUp)
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: _navigateUp,
              tooltip: LocaleKeys.file_actions_destination.tr(),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayPath,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                Text(
                  LocaleKeys.items.plural(_files.length),
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
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
                  const Icon(Icons.folder_open, size: 64, color: Colors.grey),
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
