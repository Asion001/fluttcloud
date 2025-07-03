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

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.profile_screen_title.tr()),
        actions: [
          IconButton(
            onPressed: sessionManager.signOutDevice,
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
            ),
            Text(user?.email ?? '-'),
            const SizedBox(height: 16),
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
    );
  }
}
