import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TextPreview extends StatefulWidget {
  const TextPreview({required this.uri, super.key});
  final Uri uri;

  @override
  State<TextPreview> createState() => _TextPreviewState();
}

class _TextPreviewState extends State<TextPreview> {
  String data = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final response = await Dio().getUri<String>(widget.uri);
    if (response.statusCode == 200) {
      setState(() {
        data = response.data ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: SelectableText(data));
  }
}
