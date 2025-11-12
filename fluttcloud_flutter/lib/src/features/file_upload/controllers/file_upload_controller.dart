import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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
    if (totalBytes == 0) return 0.0;
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
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: kIsWeb,
        withReadStream: !kIsWeb,
      );

      if (result == null) return;

      for (final file in result.files) {
        if (file.path == null && file.bytes == null) continue;

        final task = UploadTask(
          fileName: file.name,
          filePath: file.path ?? '',
          destinationPath: destinationPath,
          totalBytes: file.size,
        );

        _uploadTasks.add(task);
        notifyListeners();

        // Start upload
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
        type: ToastType.error,
      );
    }
  }

  Future<void> _uploadFile(UploadTask task, PlatformFile file) async {
    try {
      task.status = UploadStatus.uploading;
      task.cancelToken = CancelToken();
      notifyListeners();

      final dio = Dio();
      final serverUrl = Serverpod.I.client.host;

      // Prepare form data
      MultipartFile multipartFile;
      if (kIsWeb && file.bytes != null) {
        multipartFile = MultipartFile.fromBytes(
          file.bytes!,
          filename: file.name,
        );
      } else if (file.path != null) {
        multipartFile = await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        );
      } else {
        throw Exception('No file data available');
      }

      final formData = FormData.fromMap({
        'file': multipartFile,
        'destinationPath': task.destinationPath,
      });

      // Upload with progress tracking
      await dio.post(
        '$serverUrl/upload',
        data: formData,
        cancelToken: task.cancelToken,
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${Serverpod.I.client.authenticationKeyManager?.get()}',
          },
        ),
        onSendProgress: (sent, total) {
          task.uploadedBytes = sent;
          task.totalBytes = total;
          notifyListeners();
        },
      );

      task.status = UploadStatus.completed;
      notifyListeners();

      // Refresh file list
      await getIt<FileListController>().fetchFiles(useCache: false);

      // Check if all uploads are complete
      if (!hasActiveUploads) {
        final completedCount =
            _uploadTasks.where((t) => t.status == UploadStatus.completed).length;
        await ToastController.I.show(
          LocaleKeys.file_upload_files_uploaded.tr(args: ['$completedCount']),
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        task.status = UploadStatus.cancelled;
        task.error = LocaleKeys.file_upload_upload_cancelled.tr();
      } else {
        task.status = UploadStatus.failed;
        task.error = e.toString();
        logger.e('Upload failed: $e');
      }
      notifyListeners();
    }
  }

  void cancelUpload(UploadTask task) {
    task.cancelToken?.cancel();
    task.status = UploadStatus.cancelled;
    notifyListeners();
  }

  void clearCompletedUploads() {
    _uploadTasks.removeWhere(
      (task) =>
          task.status == UploadStatus.completed ||
          task.status == UploadStatus.failed ||
          task.status == UploadStatus.cancelled,
    );
    notifyListeners();
  }

  void clearAllUploads() {
    for (final task in _uploadTasks) {
      if (task.status == UploadStatus.uploading) {
        task.cancelToken?.cancel();
      }
    }
    _uploadTasks.clear();
    notifyListeners();
  }
}
