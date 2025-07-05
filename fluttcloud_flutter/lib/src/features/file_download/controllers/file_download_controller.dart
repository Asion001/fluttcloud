import 'package:fluttcloud_flutter/common_imports.dart';

@singleton
class FileDownloadController {
  static FileDownloadController get I => getIt<FileDownloadController>();

  Future<void> downloadFile(Uri fileUri) async {}
}
