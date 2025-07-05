import 'package:dio/dio.dart';
import 'package:fluttcloud_flutter/fluttcloud_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:universal_io/io.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({required this.uri, super.key});
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: 8.all,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: 16.circular),
      child: uri.path.endsWith('.avif')
          ? _AvifImage(uri: uri)
          : Image.network(
              uri.toString(),
              fit: BoxFit.contain,
              loadingBuilder: _loadingBuilder,
            ),
    );
  }

  Widget _loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    return loadingProgress == null
        ? child
        : CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          );
  }
}

class _AvifImage extends StatefulWidget {
  const _AvifImage({
    required this.uri,
  });

  final Uri uri;

  @override
  State<_AvifImage> createState() => _AvifImageState();
}

class _AvifImageState extends State<_AvifImage> {
  File? _tmpFile;

  @override
  void initState() {
    super.initState();
    _initializeAvifImage();
  }

  @override
  void dispose() {
    if (_tmpFile != null && _tmpFile!.existsSync()) {
      _tmpFile!.deleteSync();
      _tmpFile!.parent.deleteSync();
    }
    super.dispose();
  }

  Future<void> _initializeAvifImage() async {
    if (kIsWeb) return;
    try {
      final tmpDir = await Directory.systemTemp.createTemp('fluttcloud_');
      _tmpFile = File(
        [
          tmpDir.path,
          'image.avif',
        ].join(Platform.pathSeparator),
      );
      await Dio().downloadUri(widget.uri, _tmpFile!.path);
      setState(() {});
    } catch (e, s) {
      logger.e(e, stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return AvifImage.network(
        widget.uri.toString(),
        fit: BoxFit.contain,
        errorBuilder: _errorBuilder,
        loadingBuilder: (_, _, _) => const CircularProgressIndicator(),
      );
    }

    if (_tmpFile == null) {
      return const CircularProgressIndicator();
    }
    return AvifImage.file(
      _tmpFile!,
      fit: BoxFit.contain,
      errorBuilder: _errorBuilder,
    );
  }

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Center(
      child: Text(
        'Failed to load image: $error',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
