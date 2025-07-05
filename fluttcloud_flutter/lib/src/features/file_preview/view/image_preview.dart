import 'package:fluttcloud_flutter/fluttcloud_flutter.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({required this.uri, super.key});
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      uri.toString(),
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        return loadingProgress == null
            ? child
            : CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ).center();
      },
    );
  }
}
