import 'dart:io';

final filesDirectoryPath =
    Platform.environment['FILES_DIRECTORY_PATH'] ?? '/data';

final filesDirectory = Directory(filesDirectoryPath);
