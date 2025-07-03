import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

class ProfileBtn extends StatelessWidget {
  const ProfileBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => const ProfileRoute().push<void>(context),
      icon: const Icon(Icons.person),
    );
  }
}
