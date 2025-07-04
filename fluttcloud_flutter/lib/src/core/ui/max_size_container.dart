import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

class MaxSizeContainer extends StatelessWidget {
  const MaxSizeContainer({
    required this.child,
    super.key,
    this.maxWidth = UiModeUtils.medium,
  });
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ).flexible(),
      ],
    );
  }
}
