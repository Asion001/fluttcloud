import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class ShareLinksScreen extends StatefulWidget {
  const ShareLinksScreen({super.key});

  @override
  State<ShareLinksScreen> createState() => _ShareLinksScreenState();
}

class _ShareLinksScreenState extends State<ShareLinksScreen> {
  List<SharedLinkWithUrl> _links = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLinks();
  }

  Future<void> _loadLinks() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final links = await getIt<ShareLinksController>().getLinks();

      setState(() {
        _links = links;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaxSizeContainer(
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.share_links_title.tr()),
          actions: [
            IconButton(
              onPressed: _loadLinks,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.error.tr(),
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadLinks,
              child: Text(LocaleKeys.retry.tr()),
            ),
          ],
        ).paddingAll(16),
      );
    }

    if (_links.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.link_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.share_links_empty_title.tr(),
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.share_links_empty_description.tr(),
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ).paddingAll(16),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLinks,
      child: ListView.builder(
        padding: 16.all,
        itemCount: _links.length,
        itemBuilder: (context, index) {
          final link = _links[index];
          return ShareLinkTile(
            linkWithUrl: link,
            onEdit: () => _editLink(link),
            onDelete: () => _deleteLink(link),
            onCopy: () => _copyLink(link),
          ).paddingSymmetric(vertical: 4);
        },
      ),
    );
  }

  Future<void> _editLink(SharedLinkWithUrl linkWithUrl) async {
    final result = await EditShareLinkDialog(
      link: linkWithUrl.link,
    ).show(context);
    if (result ?? false) {
      await _loadLinks();
    }
  }

  Future<void> _deleteLink(SharedLinkWithUrl linkWithUrl) async {
    final fileName = linkWithUrl.link.serverPath.split('/').last;
    final confirm = await ConfirmDialog(
      title: LocaleKeys.share_links_delete_confirm.tr(args: [fileName]),
    ).show(context);

    if (!confirm) return;

    try {
      await getIt<ShareLinksController>().deleteLink(linkWithUrl.link.id!);
      await _loadLinks();

      await ToastController.I.show(
        LocaleKeys.share_links_deleted.tr(),
        type: ToastType.success,
      );
    } catch (e) {
      await ToastController.I.show(e.toString());
    }
  }

  Future<void> _copyLink(SharedLinkWithUrl linkWithUrl) async {
    await Clipboard.setData(ClipboardData(text: linkWithUrl.fullUrl));

    await ToastController.I.show(
      LocaleKeys.share_links_copied.tr(),
      type: ToastType.info,
    );
  }
}

class ShareLinkTile extends StatelessWidget {
  const ShareLinkTile({
    required this.linkWithUrl,
    required this.onEdit,
    required this.onDelete,
    required this.onCopy,
    super.key,
  });

  final SharedLinkWithUrl linkWithUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final link = linkWithUrl.link;
    final fileName = link.serverPath.split('/').last;
    final isExpired =
        link.deleteAfter != null && link.deleteAfter!.isBefore(DateTime.now());

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.link,
          color: isExpired
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          fileName,
          style: isExpired
              ? TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Theme.of(context).colorScheme.error,
                )
              : null,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              link.serverPath,
              style: const TextStyle(fontSize: 12),
            ).withIcon(
              Icon(
                Icons.computer,
                size: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            Text(
              linkWithUrl.fullUrl,
              style: const TextStyle(fontSize: 12),
            ).withIcon(
              Icon(
                Icons.link,
                size: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              link.deleteAfter != null
                  ? (link.deleteAfter!.isBefore(DateTime.now())
                        ? LocaleKeys.expiration_expired_on.tr(
                            args: [
                              link.deleteAfter!
                                  .toLocal()
                                  .toString()
                                  .split('.')
                                  .first,
                            ],
                          )
                        : LocaleKeys.expiration_expires_on.tr(
                            args: [
                              link.deleteAfter!
                                  .toLocal()
                                  .toString()
                                  .split('.')
                                  .first,
                            ],
                          ))
                  : LocaleKeys.expiration_never.tr(),
              style: TextStyle(
                fontSize: 11,
                color: isExpired
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.outline,
              ),
            ).withIcon(
              Icon(
                link.deleteAfter != null
                    ? (isExpired ? Icons.schedule : Icons.access_time)
                    : Icons.all_inclusive,
                size: 12,
                color: isExpired
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onCopy,
              icon: const Icon(Icons.copy),
              tooltip: LocaleKeys.share_links_copy.tr(),
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              tooltip: LocaleKeys.edit.tr(),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
              tooltip: LocaleKeys.delete.tr(),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
