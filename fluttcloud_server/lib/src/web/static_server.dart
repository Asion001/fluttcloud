import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fluttcloud_server/src/web/content_type_mapping.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';

/// A path pattern to match, and the max age that paths that match the pattern
/// should be cached for, in seconds.
class PathCacheMaxAge {
  /// Creates a new [PathCacheMaxAge] with the given [pathPattern] and [maxAge].
  PathCacheMaxAge({required this.pathPattern, required this.maxAge});

  /// The path pattern to match.
  final Pattern pathPattern;

  /// The max age that paths that match the pattern should be cached for, in
  /// seconds.
  final Duration maxAge;

  /// A value for [maxAge] that indicates that the path should not be cached.
  static const Duration noCache = Duration.zero;

  /// A value for [maxAge] that indicates that the path should be cached for
  /// one year.
  static const Duration oneYear = Duration(days: 365);

  bool _shouldCache(String path) {
    final pattern = pathPattern;

    if (pattern is String) {
      return path == pattern;
    } else if (pattern is RegExp) {
      return pattern.hasMatch(path);
    }

    return false;
  }
}

/// Route for serving a directory of static files.
class RouteStaticServer extends Route {
  /// Creates a static directory with the [serverDirectory] as its root.
  /// If [basePath] is provided, the directory will be served from that path.
  /// If [pathCachePatterns] is provided, paths matching the requested
  /// patterns will be cached for the requested amount of time. Paths that
  /// are do not match any provided pattern are cached for one year.
  RouteStaticServer({
    required this.serverDirectory,
    this.basePath,
    this.serveAsRootPath,
    List<PathCacheMaxAge>? pathCachePatterns,
  }) {
    _pathCachePatterns = pathCachePatterns;
  }

  /// The path to the directory to serve relative to the web/ directory.
  final String serverDirectory;

  /// The path to the directory to serve static files from.
  final String? basePath;

  /// The path to serve as the root path ('/'), e.g. '/index.html'.
  final String? serveAsRootPath;

  /// A regular expression that will be used to determine if a path should not
  /// be cached.
  late final List<PathCacheMaxAge>? _pathCachePatterns;

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    var path = Uri.decodeFull(request.requestedUri.path);

    final rootPath = serveAsRootPath;
    if (rootPath != null && path == '/') {
      path = rootPath;
    }

    try {
      // Remove version control string
      final dir = serverDirectory;
      var base = p.basenameWithoutExtension(path);
      var extension = p.extension(path);

      final baseParts = base.split('@');
      if (baseParts.length > 1 && baseParts.last.startsWith('v')) {
        baseParts.removeLast();
      }
      base = baseParts.join('@');

      final localBasePath = basePath;
      if (localBasePath != null && path.startsWith(localBasePath)) {
        final requestDir = p.dirname(path);
        final middlePath = requestDir.substring(localBasePath.length);

        if (middlePath.isNotEmpty) {
          path = p.join(dir, middlePath, base + extension);
        } else {
          path = p.join(dir, base + extension);
        }
      } else {
        path = p.join(dir, base + extension);
      }

      // Set content type.
      extension = extension.toLowerCase();
      final contentType = contentTypeMapping[extension];
      if (contentType != null) {
        request.response.headers.contentType = contentType;
      }

      request.response.headers.chunkedTransferEncoding = true;

      // Get the max age for the path
      final pathCacheMaxAge =
          _pathCachePatterns
              ?.firstWhereOrNull((pattern) => pattern._shouldCache(path))
              ?.maxAge ??
          // Default to a max age of one year if no pattern matched
          PathCacheMaxAge.oneYear;

      // Set Cache-Control header
      request.response.headers.set(
        'Cache-Control',
        pathCacheMaxAge == PathCacheMaxAge.noCache
            // Don't cache this path
            ? 'max-age=0, s-maxage=0, no-cache, no-store'
            // Cache for the specified amount of time, or the default
            // of one year if no pattern matched
            : 'max-age=${pathCacheMaxAge.inSeconds}',
      );

      final fileContents = await _getFile(path);
      if (fileContents == null) return false;
      await request.response.addStream(fileContents);
      return true;
    } catch (e) {
      // Couldn't find or load file.
      // Return index.html
      final fileContents = await _getFile('/index.html');
      if (fileContents == null) return false;
      await request.response.addStream(fileContents);
      return true;
    }
  }

  Future<Stream<List<int>>?> _getFile(String path) async {
    var filePath = path.startsWith('/') ? path.substring(1) : path;
    filePath = 'web/$filePath';

    final file = File(filePath);
    if (!file.existsSync()) return null;

    return file.openRead();
  }
}
