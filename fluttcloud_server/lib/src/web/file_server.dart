import 'dart:convert';
import 'dart:io' show ContentType, File, HttpRequest, HttpStatus;

import 'package:fluttcloud_server/src/core/env.dart';
import 'package:fluttcloud_server/src/utils/extensions.dart';
import 'package:fluttcloud_server/src/web/content_type_mapping.dart';
import 'package:path/path.dart';
import 'package:serverpod/serverpod.dart';

class RawFileServer extends Route {
  RawFileServer({required this.urlPrefix});
  final String urlPrefix;

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    try {
      final file = await _getFile(session, request);

      if (file == null) {
        request.response.statusCode = HttpStatus.notFound;
        request.response.add(utf8.encode('File not found'));
        return true;
      }

      request.response.headers.contentType =
          contentTypeMapping[extension(file.path)] ?? ContentType.binary;
      request.response.headers.chunkedTransferEncoding = true;
      request.response.headers.contentLength = file.statSync().size;

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

  Future<File?> _getFile(Session session, HttpRequest request) async {
    final path = Uri.decodeFull(
      request.requestedUri.path,
    ).replaceFirst(urlPrefix, '');

    final file = File([filesDirectoryPath, path].join());

    if (!(await userHasAccessToPath(session, file.path))) {
      return null;
    }

    if (!file.existsSync()) return null;

    return file;
  }

  Future<bool> userHasAccessToPath(Session session, String path) async => true;
}

class AuthenticatedFileServer extends RawFileServer {
  AuthenticatedFileServer({required super.urlPrefix});

  @override
  Future<bool> userHasAccessToPath(Session session, String path) async {
    final auth = await session.authenticated;
    return auth?.isAdmin ?? false;
  }
}
