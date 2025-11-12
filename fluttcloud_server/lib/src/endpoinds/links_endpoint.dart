import 'dart:async';
import 'dart:math';

import 'package:fluttcloud_server/common_imports.dart';
import 'package:fluttcloud_server/src/core/env.dart';
import 'package:fluttcloud_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class LinksEndpoint extends Endpoint {
  /// Returns full share url
  Future<String> create(
    Session session, {
    required String serverPath,
    DateTime? deleteAfter,
    bool canUpload = false,
  }) async {
    final auth = await _validateAccess(session);

    final linkPrefix = _generateRandomLinkPrefix();

    final link = await SharedLink.db.insertRow(
      session,
      SharedLink(
        createdBy: auth!.userId,
        serverPath: serverPath,
        linkPrefix: linkPrefix,
        deleteAfter: deleteAfter,
        canUpload: canUpload,
      ),
    );

    return _getFullUrl(session, link);
  }

  Future<List<SharedLinkWithUrl>> list(Session session, {int? userId}) async {
    final auth = await _validateAccess(session);

    // If specific user is set dont allow to see other users links
    // for not admins
    if (!auth.isAdmin && userId != null) throw const UnAuthorizedException();

    final links = await SharedLink.db.find(
      session,
      orderBy: (p0) => p0.id,
      where: (p0) => p0.createdBy.equals(userId ?? auth!.userId),
    );

    return links
        .map(
          (link) => SharedLinkWithUrl(
            link: link,
            fullUrl: _getFullUrl(session, link),
          ),
        )
        .toList();
  }

  Future<void> update(
    Session session, {
    required int linkId,
    required String serverPath,
    required DateTime? deleteAfter,
    required String? linkPrefix,
    required bool canUpload,
  }) async {
    final auth = await _validateAccess(session);

    final link = await SharedLink.db.findById(session, linkId);

    if (link == null) throw const NotFoundException();

    // Allow update only for admins and owners
    if (!auth.isAdmin && link.createdBy != auth?.userId) {
      throw const UnAuthorizedException();
    }

    await SharedLink.db.updateRow(
      session,
      SharedLink(
        id: linkId,
        createdBy: auth!.userId,
        serverPath: serverPath,
        linkPrefix: linkPrefix ?? link.linkPrefix,
        deleteAfter: deleteAfter,
        canUpload: canUpload,
      ),
    );
  }

  Future<void> delete(Session session, int linkId) async {
    final auth = await _validateAccess(session);

    final link = await SharedLink.db.findById(session, linkId);

    if (link == null) throw const NotFoundException();

    // Allow deletion only for admins and owners
    if (!auth.isAdmin && link.createdBy != auth?.userId) {
      throw const UnAuthorizedException();
    }

    await SharedLink.db.deleteRow(session, link);
  }

  String _getFullUrl(Session session, SharedLink link) {
    final webServerConfig = session.serverpod.config.webServer;
    final url = Uri(
      scheme: webServerConfig?.publicScheme,
      host: webServerConfig?.publicHost,
      port: webServerConfig?.publicPort,
      path: [publicShareLinkPrefix, link.linkPrefix].join('/'),
    );
    return url.toString();
  }

  String _generateRandomLinkPrefix({int length = 4}) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(
      length,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  Future<AuthenticationInfo?> _validateAccess(Session session) async {
    final auth = await session.authenticated;
    if (auth == null) throw const UnAuthorizedException();
    return auth;
  }

  /// Get public link information (no authentication required)
  Future<SharedLink?> getPublicLinkInfo(
    Session session,
    String linkPrefix,
  ) async {
    final link = await SharedLink.db.findFirstRow(
      session,
      where: (p0) => p0.linkPrefix.equals(linkPrefix),
    );

    // Check if link exists and hasn't expired
    if (link != null &&
        link.deleteAfter != null &&
        link.deleteAfter!.isBefore(DateTime.now())) {
      return null; // Link expired
    }

    return link;
  }
}
