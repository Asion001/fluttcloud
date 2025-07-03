import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/src/core/env.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late final Client client;

Future<void> initServerpodClient() async {
  client = Client(Env.serverUrl.toString())
    ..connectivityMonitor = FlutterConnectivityMonitor();
}
