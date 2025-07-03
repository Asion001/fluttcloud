import 'package:fluttcloud_server/src/core/auth.dart';
import 'package:fluttcloud_server/src/core/env.dart';

Future<void> serverInit() async {
  await initializeAuth();

  if (!filesDirectory.existsSync()) {
    throw Exception('Files directory does not exist: $filesDirectoryPath');
  }
}
