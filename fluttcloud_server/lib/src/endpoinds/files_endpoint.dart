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

  Future<void> deleteFile(Session session, String serverFilePath) async {
    await _validateAccess(session);

    final entity = _getEntity(serverFilePath);
    _validatePath(entity);

    // Delete associated shared links
    await SharedLink.db.deleteWhere(
      session,
      where: (p0) => p0.serverPath.like('$serverFilePath%'),
    );

    await entity.delete(recursive: entity is Directory);
  }

  Future<void> copyFile(
    Session session,
    String sourceServerPath,
    String destinationServerPath,
  ) async {
    await _validateAccess(session);

    final source = _getEntity(sourceServerPath);
    _validatePath(source);

    final destination = _getEntity(destinationServerPath);

    if (source is File) {
      await source.copy(destination.path);
    } else if (source is Directory) {
      await _copyDirectory(source, destination as Directory);
    }
  }

  Future<void> renameFile(
    Session session,
    String serverFilePath,
    String newName,
  ) async {
    await _validateAccess(session);

    final entity = _getEntity(serverFilePath);
    _validatePath(entity);

    final parentPath = entity.parent.path;
    final newPath = join(parentPath, newName);

    // Calculate new server path for shared links
    final oldServerPath = serverFilePath;
    final newServerPath = newPath.replaceFirst(filesDirectoryPath, '');

    await entity.rename(newPath);

    // Update shared links with new path
    if (entity is Directory) {
      // For directories, update all links that start with the old path
      final sharedLinks = await SharedLink.db.find(
        session,
        where: (p0) => p0.serverPath.like('$oldServerPath%'),
      );
      for (final link in sharedLinks) {
        final updatedPath = link.serverPath.replaceFirst(
          oldServerPath,
          newServerPath,
        );
        await SharedLink.db.updateRow(
          session,
          link.copyWith(serverPath: updatedPath),
        );
      }
    } else {
      // For files, update the exact match
      final sharedLinks = await SharedLink.db.find(
        session,
        where: (p0) => p0.serverPath.equals(oldServerPath),
      );
      for (final link in sharedLinks) {
        await SharedLink.db.updateRow(
          session,
          link.copyWith(serverPath: newServerPath),
        );
      }
    }
  }

  Future<void> moveFile(
    Session session,
    String sourceServerPath,
    String destinationServerPath,
  ) async {
    await _validateAccess(session);

    final source = _getEntity(sourceServerPath);
    _validatePath(source);

    final destination = _getEntity(destinationServerPath);

    await source.rename(destination.path);

    // Update shared links with new path
    final newServerPath = destination.path.replaceFirst(filesDirectoryPath, '');

    if (source is Directory) {
      // For directories, update all links that start with the old path
      final sharedLinks = await SharedLink.db.find(
        session,
        where: (p0) => p0.serverPath.like('$sourceServerPath%'),
      );
      for (final link in sharedLinks) {
        final updatedPath = link.serverPath.replaceFirst(
          sourceServerPath,
          newServerPath,
        );
        await SharedLink.db.updateRow(
          session,
          link.copyWith(serverPath: updatedPath),
        );
      }
    } else {
      // For files, update the exact match
      final sharedLinks = await SharedLink.db.find(
        session,
        where: (p0) => p0.serverPath.equals(sourceServerPath),
      );
      for (final link in sharedLinks) {
        await SharedLink.db.updateRow(
          session,
          link.copyWith(serverPath: newServerPath),
        );
      }
    }
  }

  FileSystemEntity _getEntity(String serverPath) {
    final path = [filesDirectoryPath, serverPath].join();
    final file = File(path).absolute;
    final dir = Directory(path).absolute;

    if (file.existsSync()) {
      return file;
    } else if (dir.existsSync()) {
      return dir;
    } else {
      return file; // Return file entity for validation error
    }
  }

  Future<void> _copyDirectory(Directory source, Directory destination) async {
    await destination.create(recursive: true);

    await for (final entity in source.list()) {
      final name = basename(entity.path);
      if (entity is Directory) {
        final newDirectory = Directory(join(destination.path, name));
        await _copyDirectory(entity, newDirectory);
      } else if (entity is File) {
        await entity.copy(join(destination.path, name));
      }
    }
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
