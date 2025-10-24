import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

class CreateShareLinkDialog extends StatefulWidget {
  const CreateShareLinkDialog({
    required this.file,
    super.key,
  });

  final FsEntry file;

  Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  State<CreateShareLinkDialog> createState() => _CreateShareLinkDialogState();
}

class _CreateShareLinkDialogState extends State<CreateShareLinkDialog> {
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
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
    final fileName = widget.file.fullpath.split('/').last;

    return AlertDialog(
      title: Text(
        LocaleKeys.share_link_create_title.tr(),
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
              LocaleKeys.share_link_create_description.tr(args: [fileName]),
              style: context.textTheme.bodyMedium,
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
          ],
        ),
      ),
      actions: [
        Row(
          spacing: 16,
          children: [
            OutlinedButton(
              onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
              child: Text(LocaleKeys.cancel.tr()),
            ).expand(),
            FilledButton(
              onPressed: _isCreating ? null : _createShareLink,
              child: _isCreating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(LocaleKeys.share_link_create.tr()),
            ).expand(),
          ],
        ),
      ],
    );
  }

  Future<void> _createShareLink() async {
    setState(() {
      _isCreating = true;
    });

    try {
      await getIt<ShareLinksController>().create(
        widget.file,
        deleteAfter: _selectedExpiration,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
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
