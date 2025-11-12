import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/foundation.dart';

class UploadTask {
  UploadTask({
    required this.fileName,
    required this.filePath,
    required this.destinationPath,
    this.totalBytes = 0,
    this.uploadedBytes = 0,
    this.status = UploadStatus.pending,
    this.error,
  });

  final String fileName;
  final String filePath;
  final String destinationPath;
  int totalBytes;
  int uploadedBytes;
  UploadStatus status;
  String? error;
  CancelToken? cancelToken;

  double get progress {
    if (totalBytes == 0) return 0;
    return uploadedBytes / totalBytes;
  }

  String get progressPercent {
    return '${(progress * 100).toStringAsFixed(0)}%';
  }
}

enum UploadStatus {
  pending,
  uploading,
  completed,
  failed,
  cancelled,
}

@singleton
class FileUploadController extends ChangeNotifier {
  static FileUploadController get I => getIt<FileUploadController>();

  final List<UploadTask> _uploadTasks = [];
  List<UploadTask> get uploadTasks => List.unmodifiable(_uploadTasks);

  bool get hasActiveUploads => _uploadTasks.any(
    (task) =>
        task.status == UploadStatus.uploading ||
        task.status == UploadStatus.pending,
  );

  int get activeUploadCount => _uploadTasks
      .where(
        (task) =>
            task.status == UploadStatus.uploading ||
            task.status == UploadStatus.pending,
      )
      .length;

  Future<void> pickAndUploadFiles(String destinationPath) async {
    logger.i('Starting file picker for destination: $destinationPath');
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: kIsWeb,
        withReadStream: !kIsWeb,
      );

      if (result == null) {
        logger.i('File picker cancelled by user');
        return;
      }

      logger.i('Selected ${result.files.length} files for upload');

      for (final file in result.files) {
        if (file.path == null && file.bytes == null) {
          logger.w('Skipping file ${file.name}: no path or bytes available');
          continue;
        }

        logger.i(
          'Creating upload task for ${file.name} (${file.size} bytes)',
        );
        final task = UploadTask(
          fileName: file.name,
          filePath: file.path ?? '',
          destinationPath: destinationPath,
          totalBytes: file.size,
        );

        _uploadTasks.add(task);
        notifyListeners();

        // Start upload
        logger.i('Starting upload for ${file.name}');
        unawaited(_uploadFile(task, file));
      }

      await ToastController.I.show(
        LocaleKeys.file_upload_upload_in_progress.tr(),
        type: ToastType.info,
      );
    } catch (e) {
      logger.e('Error picking files: $e');
      await ToastController.I.show(
        LocaleKeys.file_upload_upload_failed.tr(),
      );
    }
  }

  Future<void> _uploadFile(UploadTask task, PlatformFile file) async {
    logger.i('Starting upload for ${task.fileName}');
    try {
      task
        ..status = UploadStatus.uploading
        ..cancelToken = CancelToken();
      notifyListeners();

      final dio = Dio();
      logger.d('Requesting upload URL from server');
      final serverUrl = await Serverpod.I.client.files.getUploadUrl();
      // Prepare form data
      logger
        ..d('Upload URL received: $serverUrl')
        ..d('Preparing multipart form data for ${task.fileName}');
      MultipartFile multipartFile;
      if (kIsWeb && file.bytes != null) {
        logger.d('Using bytes for web upload (${file.bytes!.length} bytes)');
        multipartFile = MultipartFile.fromBytes(
          file.bytes!,
          filename: file.name,
        );
      } else if (file.path != null) {
        logger.d('Using file path for upload: ${file.path}');
        multipartFile = await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        );
      } else {
        logger.e('No file data available for ${task.fileName}');
        throw Exception(LocaleKeys.file_upload_no_file_data_available.tr());
      }

      final formData = FormData.fromMap({
        'file': multipartFile,
        'destinationPath': task.destinationPath,
      });

      try {
        // Upload with progress tracking
        logger.d('Getting authentication header');
        final headerValue = await Serverpod.I.client.authenticationKeyManager
            ?.get();
        logger.i(
          'Uploading ${task.fileName} to $serverUrl (${task.totalBytes} bytes)',
        );
        final result = await dio.postUri<Map<String, dynamic>>(
          serverUrl.replace(
            queryParameters: {
              ...serverUrl.queryParameters,
              'auth': headerValue,
            },
          ),
          data: formData,
          cancelToken: task.cancelToken,
          options: Options(
            extra: {'Authorization': headerValue, 'X-test': '123'},
          ),
          onSendProgress: (sent, total) {
            task
              ..uploadedBytes = sent
              ..totalBytes = total;
            if (sent % (total ~/ 10) == 0 || sent == total) {
              logger.d(
                'Upload progress ${task.fileName}: ${(sent / total * 100).toStringAsFixed(1)}% ($sent/$total bytes)',
              );
            }
            notifyListeners();
          },
        );

        logger.d('Upload response received for ${task.fileName}');
        final responseData = UploadResult.fromJson(result.data!);
        if (responseData.success != true) {
          logger.e(
            'Upload failed on server side for ${task.fileName}',
          );
          throw Exception(
            LocaleKeys.file_upload_upload_failed_server_side.tr(),
          );
        }
        logger.i('Upload completed successfully for ${task.fileName}');
        task.status = UploadStatus.completed;
        notifyListeners();
      } catch (e) {
        logger.e('Upload error for ${task.fileName}: $e');
        task
          ..status = UploadStatus.failed
          ..error = e.toString();
        notifyListeners();
        return;
      }

      // Refresh file list
      logger.d('Refreshing file list after upload completion');
      await getIt<FileListController>().fetchFiles(useCache: false);

      // Check if all uploads are complete
      if (!hasActiveUploads) {
        final completedCount = _uploadTasks
            .where((t) => t.status == UploadStatus.completed)
            .length;
        logger.i('All uploads complete. $completedCount files uploaded');
        await ToastController.I.show(
          LocaleKeys.file_upload_files_uploaded.tr(args: ['$completedCount']),
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        logger.w('Upload cancelled for ${task.fileName}');
        task
          ..status = UploadStatus.cancelled
          ..error = LocaleKeys.file_upload_upload_cancelled.tr();
      } else {
        logger.e('Upload failed for ${task.fileName}: $e');
        task
          ..status = UploadStatus.failed
          ..error = e.toString();
      }
      notifyListeners();
    }
  }

  void cancelUpload(UploadTask task) {
    logger.i('Cancelling upload for ${task.fileName}');
    task.cancelToken?.cancel();
    task.status = UploadStatus.cancelled;
    notifyListeners();
  }

  void clearCompletedUploads() {
    final removedCount = _uploadTasks
        .where(
          (task) =>
              task.status == UploadStatus.completed ||
              task.status == UploadStatus.failed ||
              task.status == UploadStatus.cancelled,
        )
        .length;
    logger.i('Clearing $removedCount completed uploads');
    _uploadTasks.removeWhere(
      (task) =>
          task.status == UploadStatus.completed ||
          task.status == UploadStatus.failed ||
          task.status == UploadStatus.cancelled,
    );
    notifyListeners();
  }

  void clearAllUploads() {
    final activeCount = _uploadTasks
        .where((task) => task.status == UploadStatus.uploading)
        .length;
    logger.i(
      'Clearing all uploads ($activeCount active, '
      '${_uploadTasks.length} total)',
    );
    for (final task in _uploadTasks) {
      if (task.status == UploadStatus.uploading) {
        logger.d('Cancelling active upload: ${task.fileName}');
        task.cancelToken?.cancel();
      }
    }
    _uploadTasks.clear();
    notifyListeners();
  }
}
