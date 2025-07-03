import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({required this.title, required this.onTap, super.key});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title).flexible(),
        IconButton(onPressed: onTap, icon: const Icon(Icons.add)),
      ],
    );
  }
}
