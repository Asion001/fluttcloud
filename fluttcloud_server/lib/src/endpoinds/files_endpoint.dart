import 'dart:async';
import 'dart:io';

import 'package:fluttcloud_server/common_imports.dart';
import 'package:fluttcloud_server/src/core/env.dart';
import 'package:fluttcloud_server/src/generated/protocol.dart';
import 'package:fluttcloud_server/src/web/content_type_mapping.dart';
import 'package:path/path.dart';
import 'package:serverpod/serverpod.dart';

class FilesEndpoint extends Endpoint {
  Stream<FsEntry> list(
    Session session, {
    String? serverFolderPath,
  }) async* {
    await _validateAccess(session);

    final directory = Directory(
      [
        filesDirectoryPath,
        if (serverFolderPath != null) serverFolderPath,
      ].join(),
    ).absolute;

    _validatePath(directory);

    final stream = directory.list(followLinks: false);

    await for (final entity in stream) {
      final fsEntry = _convertToFsEntry(session, entity, directory);
      yield fsEntry;
    }
  }

  Future<Uri> getPrivateUri(Session session, String serverFilePath) async {
    await _validateAccess(session);

    final file = File([filesDirectoryPath, serverFilePath].join()).absolute;
    _validatePath(file);

    final host = session.endpoint;
    final hostUri = Uri.parse(host);
    return hostUri.replace(path: [privateShareLinkPrefix, file.path].join());
  }

  Future<void> _validateAccess(Session session) async {
    final auth = await session.authenticated;
    if (!auth.isAdmin) {
      throw const UnAuthorizedException();
    }
  }

  void _validatePath(FileSystemEntity entity) {
    // Check for '../../' in path
    if (!entity.absolute.path.startsWith(filesDirectoryPath)) {
      throw const NotFoundException();
    }
    if (!entity.existsSync()) {
      throw const NotFoundException();
    }
  }

  FsEntry _convertToFsEntry(
    Session session,
    FileSystemEntity entity,
    Directory parent,
  ) {
    final path = entity.absolute.path;
    final serverFullpath = path.replaceFirst(filesDirectoryPath, '');
    final stat = entity.statSync();
    final type = entity is File
        ? FsEntryType.file
        : entity is Directory
        ? FsEntryType.directory
        : FsEntryType.symlink;
    final contentType =
        contentTypeMapping[extension(path).toLowerCase()] ??
        FsEntryContentType.binary;
    final fsContentType = FsEntryContentType.values.firstWhere(
      (e) => e.name == contentType.toString().split('/').first,
      orElse: () => FsEntryContentType.binary,
    );

    final webServerUri = Uri(
      scheme: session.serverpod.config.webServer?.publicScheme,
      host: session.serverpod.config.webServer?.publicHost,
      port: session.serverpod.config.webServer?.publicPort,
    );
    final privateSharePath = [privateShareLinkPrefix, serverFullpath].join();
    final privateShareUrl = webServerUri
        .replace(
          path: privateSharePath,
          queryParameters: {'auth': session.authenticationKey},
        )
        .toString();

    return FsEntry(
      fullpath: path,
      serverFullpath: serverFullpath,
      parentPath: parent.absolute.path.replaceFirst(filesDirectoryPath, ''),
      type: type,
      size: stat.size,
      updatedAt: stat.modified,
      createdAt: stat.changed,
      privateShareUrl: privateShareUrl,
      contentType: fsContentType,
    );
  }
}
