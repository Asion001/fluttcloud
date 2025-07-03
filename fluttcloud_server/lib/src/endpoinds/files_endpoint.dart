import 'dart:async';
import 'dart:io';

import 'package:fluttcloud_server/common_imports.dart';
import 'package:fluttcloud_server/src/core/env.dart';
import 'package:fluttcloud_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class FilesEndpoint extends Endpoint {
  Stream<FsEntry> list(Session session, {String? serverFolderPath}) async* {
    final auth = await session.authenticated;

    if (!auth.isAdmin) {
      throw const UnAuthorizedException();
    }

    final directory = Directory(
      [
        filesDirectoryPath,
        if (serverFolderPath != null) serverFolderPath,
      ].join(),
    ).absolute;

    // Check for '../../' in path
    if (!directory.path.startsWith(filesDirectoryPath)) {
      throw const NotFoundException();
    }

    final stream = directory.list(followLinks: false);

    await for (final entity in stream) {
      yield _convertToFsEntry(entity);
    }
  }

  FsEntry _convertToFsEntry(FileSystemEntity entity) {
    final path = entity.absolute.path;
    final serverFullpath = path.replaceFirst(filesDirectoryPath, '');
    final stat = entity.statSync();
    final type = entity is File
        ? FsEntryType.file
        : entity is Directory
        ? FsEntryType.directory
        : FsEntryType.symlink;

    return FsEntry(
      fullpath: path,
      serverFullpath: serverFullpath,
      type: type,
      size: stat.size,
      updatedAt: stat.modified,
      createdAt: stat.changed,
    );
  }
}
