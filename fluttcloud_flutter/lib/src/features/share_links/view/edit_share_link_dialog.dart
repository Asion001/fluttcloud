import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

class EditShareLinkDialog extends StatefulWidget {
  const EditShareLinkDialog({
    required this.link,
    super.key,
  });

  final SharedLink link;

  Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  State<EditShareLinkDialog> createState() => _EditShareLinkDialogState();
}

class _EditShareLinkDialogState extends State<EditShareLinkDialog> {
  DateTime? _selectedExpiration;
  final List<_ExpirationOption> _expirationOptions = [
    _ExpirationOption(
      label: LocaleKeys.expiration_never.tr(),
      duration: null,
    ),
    _ExpirationOption(
      label: LocaleKeys.expiration_in_hours.plural(1),
      duration: const Duration(hours: 1),
    ),
    _ExpirationOption(
      label: LocaleKeys.expiration_in_hours.plural(6),
      duration: const Duration(hours: 6),
    ),
    _ExpirationOption(
      label: LocaleKeys.expiration_in_days.plural(1),
      duration: const Duration(days: 1),
    ),
    _ExpirationOption(
      label: LocaleKeys.expiration_in_days.plural(7),
      duration: const Duration(days: 7),
    ),
    _ExpirationOption(
      label: LocaleKeys.expiration_in_days.plural(30),
      duration: const Duration(days: 30),
    ),
  ];

  int _selectedExpirationIndex = 0;
  bool _isUpdating = false;
  late bool _canUpload;
  late final TextEditingController _linkPrefixController;

  @override
  void initState() {
    super.initState();
    _linkPrefixController = TextEditingController(text: widget.link.linkPrefix);
    _selectedExpiration = widget.link.deleteAfter;
    _canUpload = widget.link.canUpload;

    // Find the closest matching expiration option
    if (_selectedExpiration != null) {
      final now = DateTime.now();
      final duration = _selectedExpiration!.difference(now);

      if (duration.inDays >= 30) {
        _selectedExpirationIndex = 5; // 30 days
      } else if (duration.inDays >= 7) {
        _selectedExpirationIndex = 4; // 7 days
      } else if (duration.inDays >= 1) {
        _selectedExpirationIndex = 3; // 1 day
      } else if (duration.inHours >= 6) {
        _selectedExpirationIndex = 2; // 6 hours
      } else if (duration.inHours >= 1) {
        _selectedExpirationIndex = 1; // 1 hour
      } else {
        _selectedExpirationIndex = 0; // Never expires
        _selectedExpiration = null;
      }
    }
  }

  @override
  void dispose() {
    _linkPrefixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.link.serverPath.split('/').last;

    return AlertDialog(
      title: Text(
        LocaleKeys.share_links_edit_title.tr(),
        style: context.textTheme.titleMedium,
      ),
      insetPadding: 16.all,
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.share_links_edit_description.tr(args: [fileName]),
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.share_links_link_prefix.tr(),
              style: context.textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _linkPrefixController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'abc123',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.expiration_expiration.tr(),
              style: context.textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: _selectedExpirationIndex,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: _expirationOptions.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(option.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedExpirationIndex = value!;
                  final duration = _expirationOptions[value].duration;
                  _selectedExpiration = duration != null
                      ? DateTime.now().add(duration)
                      : null;
                });
              },
            ),
            if (_selectedExpiration != null) ...[
              const SizedBox(height: 8),
              Text(
                LocaleKeys.expiration_expires_on.tr(
                  args: [
                    _selectedExpiration!.toLocal().toString().split('.').first,
                  ],
                ),
                style: context.textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _canUpload,
              onChanged: (value) {
                setState(() {
                  _canUpload = value ?? false,
                });
              },
              title: Text(
                LocaleKeys.share_link_allow_upload.tr(),
                style: context.textTheme.bodyMedium,
              ),
              subtitle: Text(
                LocaleKeys.share_link_allow_upload_description.tr(),
                style: context.textTheme.bodySmall,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          spacing: 16,
          children: [
            OutlinedButton(
              onPressed: _isUpdating
                  ? null
                  : () => Navigator.of(context).pop(false),
              child: Text(LocaleKeys.cancel.tr()),
            ).expand(),
            FilledButton(
              onPressed: _isUpdating ? null : _updateShareLink,
              child: _isUpdating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(LocaleKeys.save.tr()),
            ).expand(),
          ],
        ),
      ],
    );
  }

  Future<void> _updateShareLink() async {
    final linkPrefix = _linkPrefixController.text.trim();

    if (linkPrefix.isEmpty) {
      await ToastController.I.show(
        LocaleKeys.share_links_prefix_required.tr(),
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      await getIt<ShareLinksController>().updateLink(
        linkId: widget.link.id!,
        serverPath: widget.link.serverPath,
        linkPrefix: linkPrefix,
        deleteAfter: _selectedExpiration,
        canUpload: _canUpload,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }

      await ToastController.I.show(
        LocaleKeys.share_links_updated.tr(),
        type: ToastType.success,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }

      await ToastController.I.show(e.toString());
    }
  }
}

class _ExpirationOption {
  const _ExpirationOption({
    required this.label,
    required this.duration,
  });

  final String label;
  final Duration? duration;
}
