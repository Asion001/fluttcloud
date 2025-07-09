import 'dart:io';

/// Path to shared files directory
///
/// Default is '/data'
final String filesDirectoryPath =
    Platform.environment['FILES_DIRECTORY_PATH'] ?? '/data';
final filesDirectory = Directory(filesDirectoryPath);

final String privateShareLinkPrefix =
    Platform.environment['PRIVATE_SHARE_LINK_PREFIX'] ?? '/raw';

final String publicShareLinkPrefix =
    Platform.environment['PRIVATE_SHARE_LINK_PREFIX'] ?? '/share';

/// Allows registration of new users,
/// if its false registration allowed only for first user who will become admin
///
/// Default is false.
final bool allowRegistration =
    Platform.environment['ALLOW_REGISTRATION'] == '1';
