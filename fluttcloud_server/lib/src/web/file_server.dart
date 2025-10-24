import 'dart:convert';
import 'dart:io' show ContentType, File, HttpRequest, HttpStatus;

import 'package:fluttcloud_server/common_imports.dart';
import 'package:fluttcloud_server/src/core/env.dart';
import 'package:fluttcloud_server/src/generated/shared_link.dart';
import 'package:fluttcloud_server/src/web/content_type_mapping.dart';
import 'package:path/path.dart';
import 'package:serverpod/serverpod.dart';

class RawFileServer extends Route {
  RawFileServer({required this.urlPrefix});
  final String urlPrefix;

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    try {
      final file = await _getFile(session, request.requestedUri.path);

      if (file == null) {
        request.response.statusCode = HttpStatus.notFound;
        request.response.add(utf8.encode('File not found'));
        return true;
      }

      request.response.headers.contentType =
          contentTypeMapping[extension(file.path)] ?? ContentType.binary;
      request.response.headers.chunkedTransferEncoding = true;
      request.response.headers.contentLength = file.statSync().size;
      _addExtraHeaders(request, file);

      await request.response.addStream(file.openRead());
      return true;
    } catch (e, s) {
      session.log(
        e.toString(),
        exception: e,
        level: LogLevel.error,
        stackTrace: s,
      );
      return false;
    }
  }

  void _addExtraHeaders(HttpRequest request, File file) {
    if (request.requestedUri.queryParameters['download'] == '1') {
      request.response.headers.add(
        'Content-Disposition',
        'attachment; filename="${file.path.split('/').last}"',
      );
    }
  }

  Future<File?> _getFile(Session session, String requestPath) async {
    final path = Uri.decodeFull(requestPath).replaceFirst(urlPrefix, '');

    final filePath = await _userHasAccessToRequestPath(session, path);
    if (filePath == null) {
      session.log(
        'Unauthorized access to path: $path',
        level: LogLevel.debug,
      );
      return null;
    }

    final file = File(filePath);
    if (!(await _userHasAccessToPath(session, file.path))) {
      session.log(
        'Unauthorized access to file: ${file.path}',
        level: LogLevel.debug,
      );
      return null;
    }

    if (!file.existsSync()) {
      session.log(
        'File does not exist: ${file.path}',
        level: LogLevel.debug,
      );
      return null;
    }

    return file;
  }

  Future<bool> _userHasAccessToPath(
    Session session,
    String filePath,
  ) async => true;

  Future<String?> _userHasAccessToRequestPath(
    Session session,
    String requestPath,
  ) async => [filesDirectoryPath, requestPath].join();
}

class AuthenticatedFileServer extends RawFileServer {
  AuthenticatedFileServer({required super.urlPrefix});

  @override
  Future<bool> _userHasAccessToPath(
    Session session,
    String filePath,
  ) async {
    final auth = await session.authenticated;
    return auth?.isAdmin ?? false;
  }
}

class PublicShareFileServer extends RawFileServer {
  PublicShareFileServer({required super.urlPrefix});

  @override
  Future<String?> _userHasAccessToRequestPath(
    Session session,
    String requestPath,
  ) async {
    final publicLink = await SharedLink.db.findFirstRow(
      session,
      where: (p0) => p0.linkPrefix.equals(requestPath.replaceFirst('/', '')),
    );
    final linkPath = publicLink?.serverPath;
    if (linkPath == null) return null;
    return [filesDirectoryPath, linkPath].join();
  }
}
