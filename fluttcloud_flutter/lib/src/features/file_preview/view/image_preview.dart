import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({required this.uri, super.key});
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Image.network(uri.toString(), fit: BoxFit.contain);
  }
}
