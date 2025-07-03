import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

late String serverUrl;

void main() async {
  await AppInit.init();
  runApp(localizationWrapper(const App()));
}
