import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/fluttcloud_flutter.dart';
import 'package:flutter/services.dart';

@singleton
class ShareLinksController {
  Future<void> create(
    FsEntry entry, {
    DateTime? deleteAfter,
    bool canUpload = false,
  }) async {
    try {
      final link = await Serverpod.I.client.links.create(
        serverPath: entry.serverFullpath,
        deleteAfter: deleteAfter,
        canUpload: canUpload,
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

  Future<List<SharedLinkWithUrl>> getLinks({int? userId}) async {
    try {
      return await Serverpod.I.client.links.list(userId: userId);
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  Future<void> updateLink({
    required int linkId,
    required String serverPath,
    required String linkPrefix,
    required DateTime? deleteAfter,
    required bool canUpload,
  }) async {
    try {
      await Serverpod.I.client.links.update(
        linkId: linkId,
        serverPath: serverPath,
        linkPrefix: linkPrefix,
        deleteAfter: deleteAfter,
        canUpload: canUpload,
      );
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  Future<void> deleteLink(int linkId) async {
    try {
      await Serverpod.I.client.links.delete(linkId);
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
