import 'dart:io';

import 'package:fluttcloud_server/common_imports.dart';
import 'package:fluttcloud_server/src/core/env.dart';
import 'package:fluttcloud_server/src/generated/protocol.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';

class PublicUploadRoute extends Route {
  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    // Only handle POST requests
    if (request.method != 'POST') {
      request.response.statusCode = HttpStatus.methodNotAllowed;
      request.response.write('Only POST method is allowed');
      return true;
    }

    try {
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

      String? linkPrefix;
      String? fileName;
      List<int>? fileData;

      // Parse the multipart data
      await for (final part
          in request.cast<List<int>>().transform(MimeMultipartTransformer(boundary))) {
        final contentDisposition = part.headers['content-disposition'];
        if (contentDisposition == null) continue;

        final match = RegExp(r'name="([^"]+)"').firstMatch(contentDisposition);
        if (match == null) continue;

        final fieldName = match.group(1);
        final data = await part.toList();
        final content = data.expand((x) => x).toList();

        if (fieldName == 'linkPrefix') {
          linkPrefix = String.fromCharCodes(content);
        } else if (fieldName == 'file') {
          final fileMatch =
              RegExp(r'filename="([^"]+)"').firstMatch(contentDisposition);
          if (fileMatch != null) {
            fileName = fileMatch.group(1);
            fileData = content;
          }
        }
      }

      if (linkPrefix == null || fileName == null || fileData == null) {
        request.response.statusCode = HttpStatus.badRequest;
        request.response.write(
          'Missing required fields: linkPrefix, fileName, or file data',
        );
        return true;
      }

      // Validate the shared link and get the folder path
      final sharedLink = await SharedLink.db.findFirstRow(
        session,
        where: (p0) => p0.linkPrefix.equals(linkPrefix),
      );

      if (sharedLink == null) {
        request.response.statusCode = HttpStatus.notFound;
        request.response.write('Invalid link');
        return true;
      }

      // Check if the link allows uploads
      if (!sharedLink.canUpload) {
        request.response.statusCode = HttpStatus.forbidden;
        request.response.write('Upload not allowed for this link');
        return true;
      }

      // Check if the link has expired
      if (sharedLink.deleteAfter != null &&
          sharedLink.deleteAfter!.isBefore(DateTime.now())) {
        request.response.statusCode = HttpStatus.gone;
        request.response.write('Link has expired');
        return true;
      }

      // Get the destination directory from the shared link
      final destinationPath = sharedLink.serverPath;
      final fullDestPath = path.join(filesDirectoryPath, destinationPath);
      final destDir = Directory(fullDestPath);

      // Verify it's a directory
      if (!await destDir.exists() || !(await destDir.stat()).type == FileSystemEntityType.directory) {
        request.response.statusCode = HttpStatus.badRequest;
        request.response.write('Shared link does not point to a folder');
        return true;
      }

      // Save the file
      final filePath = path.join(fullDestPath, fileName);
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
      request.response.write(
        session.serializationManager.encodeWithType(response),
      );

      return true;
    } catch (e, stackTrace) {
      session.log(
        'Public upload error: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );

      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write('Upload failed: $e');
      return true;
    }
  }
}
