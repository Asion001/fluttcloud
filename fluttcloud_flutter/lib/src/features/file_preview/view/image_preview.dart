import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({required this.uri, super.key});
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    if (uri.path.endsWith('.avif')) {
      return AvifImage.network(
        uri.toString(),
        fit: BoxFit.contain,
        loadingBuilder: _loadingBuilder,
      );
    }

    return Image.network(
      uri.toString(),
      fit: BoxFit.contain,
      loadingBuilder: _loadingBuilder,
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
