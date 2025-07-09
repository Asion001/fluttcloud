import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/fluttcloud_flutter.dart';
import 'package:flutter/services.dart';

@singleton
class ShareLinksController {
  Future<void> create(FsEntry entry, {DateTime? deleteAfter}) async {
    if (entry.type != FsEntryType.file) return;
    
    try {
      final link = await Serverpod.I.client.links.create(
        serverPath: entry.serverFullpath,
        deleteAfter: deleteAfter,
      );

      await Clipboard.setData(ClipboardData(text: link));
      await ToastController.I.show(
        link,
        title: LocaleKeys.link_sharing_created.tr(),
        type: ToastType.info,
      );
    } catch (e) {
      logger.e(e);
      await ToastController.I.show(e);
    }
  }
}
