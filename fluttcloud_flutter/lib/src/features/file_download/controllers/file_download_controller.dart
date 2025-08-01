import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:url_launcher/url_launcher.dart';

@singleton
class FileDownloadController {
  static FileDownloadController get I => getIt<FileDownloadController>();

  Future<void> downloadFile(Uri fileUri) async {
    await launchUrl(fileUri);
  }
}
