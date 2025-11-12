import 'dart:convert';
import 'dart:io';

import 'package:fluttcloud_server/common_imports.dart';
import 'package:fluttcloud_server/src/core/env.dart';
import 'package:fluttcloud_server/src/generated/protocol.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';

class FileUploadRoute extends Route {
  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    // Only handle POST requests
    if (request.method != 'POST') {
      request.response.statusCode = HttpStatus.methodNotAllowed;
      request.response.write('Only POST method is allowed');
      return true;
    }

    try {
      // Verify authentication
      final auth = await session.authenticated;
      if (auth == null) {
        request.response.statusCode = HttpStatus.unauthorized;
        request.response.write('Authentication required');
        return true;
      }

      // Parse multipart form data
      final contentType = request.headers.contentType;
      if (contentType == null ||
          !contentType.mimeType.contains('multipart/form-data')) {
        request.response.statusCode = HttpStatus.badRequest;
        request.response.write('Content-Type must be multipart/form-data');
        return true;
      }

      final boundary = contentType.parameters['boundary'];
      if (boundary == null) {
        request.response.statusCode = HttpStatus.badRequest;
        request.response.write('Missing boundary in Content-Type');
        return true;
      }

      String? destinationPath;
      String? fileName;
      List<int>? fileData;
      // Parse the multipart data
      await for (final part in request.cast<List<int>>().transform(
        MimeMultipartTransformer(boundary),
      )) {
        final contentDisposition = part.headers['content-disposition'];
        if (contentDisposition == null) continue;

        final match = RegExp('name="([^"]+)"').firstMatch(contentDisposition);
        if (match == null) continue;

        final fieldName = match.group(1);
        final data = await part.toList();
        final content = data.expand((x) => x).toList();

        if (fieldName == 'destinationPath') {
          destinationPath = utf8.decode(content);
        } else if (fieldName == 'file') {
          final fileMatch = RegExp(
            'filename="([^"]+)"',
          ).firstMatch(contentDisposition);
          if (fileMatch != null) {
            fileName = fileMatch.group(1);
            fileData = content;
          }
        }
      }

      if (destinationPath == null || fileName == null || fileData == null) {
        request.response.statusCode = HttpStatus.badRequest;
        request.response.write(
          'Missing required fields: destinationPath, fileName, or file data',
        );
        return true;
      }

      // Validate destination path access
      await _validateAccess(session, destinationPath, auth);

      // Create the destination directory if it doesn't exist
      final fullDestPath = path.joinAll([filesDirectoryPath, destinationPath]);
      final destDir = Directory(fullDestPath);
      if (!destDir.existsSync()) {
        await destDir.create(recursive: true);
      }

      // Save the file
      final filePath = path.joinAll([fullDestPath, fileName]);
      final file = File(filePath);
      await file.writeAsBytes(fileData);

      // Return success response
      request.response.statusCode = HttpStatus.ok;
      request.response.headers.contentType = ContentType.json;

      final response = UploadResult(
        success: true,
        filePath: path.join(destinationPath, fileName),
        fileName: fileName,
      );
      request.response.write(jsonEncode(response.toJson()));

      return true;
    } catch (e, stackTrace) {
      session.log(
        'Upload error: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );

      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write('Upload failed: $e');
      return true;
    }
  }

  Future<void> _validateAccess(
    Session session,
    String serverPath,
    AuthenticationInfo auth,
  ) async {
    // Admins have access to all files
    if (auth.isAdmin) {
      return;
    }

    // For non-admin users, check folder access
    final normalizedPath = serverPath.startsWith('/')
        ? serverPath
        : '/$serverPath';

    // Find folders where normalizedPath starts with folderPath
    // Using custom expression to check if normalizedPath LIKE folderPath || '%'
    final folder = await UserFolderAccess.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(auth.userId) & t.folderPath.like('$normalizedPath%'),
    );

    // Check if any folder is a prefix of the normalized path
    final hasAccess =
        folder != null && normalizedPath.startsWith(folder.folderPath);
    if (!hasAccess) {
      throw const UnAuthorizedException();
    }
  }
}
