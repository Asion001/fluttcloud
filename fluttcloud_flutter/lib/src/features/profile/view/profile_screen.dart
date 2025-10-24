import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionManager = Serverpod.I.sessionManager;
    final user = sessionManager.signedInUser;
    final image = user?.imageUrl;
    final isAdmin = user?.scopeNames.contains('serverpod.admin') ?? false;

    return MaxSizeContainer(
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.profile_screen_title.tr()),
          actions: [
            IconButton(
              onPressed: Serverpod.I.logout,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Container(
          padding: 24.all,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surfaceBright,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                foregroundImage: image.isEmptyOrNull
                    ? null
                    : NetworkImage(image!),
                radius: 48,
                onForegroundImageError: (exception, stackTrace) {},
              ),
              Text(user?.email ?? '-'),
              const SizedBox(height: 16),
              if (isAdmin)
                FilledButton.icon(
                  onPressed: () => context.router.pushPath('/user-management'),
                  icon: const Icon(Icons.admin_panel_settings),
                  label: Text(LocaleKeys.user_management_title.tr()),
                ),
              FilledButton.icon(
                onPressed: () => context.router.pushPath('/share-links'),
                icon: const Icon(Icons.link),
                label: Text(LocaleKeys.share_links_title.tr()),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  final confirm = await ConfirmDialog(
                    title: '${LocaleKeys.profile_screen_delete_account.tr()}?',
                  ).show(context);
                  if (!confirm) return;
                  await Serverpod.I.client.user.deleteMyUserProfile();
                  await Serverpod.I.sessionManager.signOutDevice();
                },
                child: Text(LocaleKeys.profile_screen_delete_account.tr()),
              ),
            ],
          ),
        ).center(),
      ),
    );
  }
}
