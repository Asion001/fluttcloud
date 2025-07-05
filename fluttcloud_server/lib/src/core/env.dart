import 'dart:io';

/// Path to shared files directory
///
/// Default is '/data'
final filesDirectoryPath =
    Platform.environment['FILES_DIRECTORY_PATH'] ?? '/data';
final filesDirectory = Directory(filesDirectoryPath);

final privateShareLinkPrefix =
    Platform.environment['PRIVATE_SHARE_LINK_PREFIX'] ?? '/share/root';

/// Allows registration of new users,
/// if its false registration allowed only for first user who will become admin
///
/// Default is false.
final allowRegistration = Platform.environment['ALLOW_REGISTRATION'] == '1';
