// ignore_for_file: avoid_print

import 'package:fluttcloud_server/server.dart';

/// This is the starting point for your Serverpod server. Typically, there is
/// no need to modify this file.
void main(List<String> args) async {
  try {
    await run(args);
  } catch (e, st) {
    print('Error starting server: $e');
    print(st);
  }
}
