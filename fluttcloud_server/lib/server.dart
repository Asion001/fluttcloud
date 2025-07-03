import 'package:fluttcloud_server/src/core/server_init.dart';
import 'package:fluttcloud_server/src/generated/endpoints.dart';
import 'package:fluttcloud_server/src/generated/protocol.dart';
import 'package:fluttcloud_server/src/web/static_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

Future<void> run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth.authenticationHandler,
  );

  await serverInit();

  final routeStaticDirectory = RouteStaticServer(
    serverDirectory: 'app',
    basePath: '/',
    serveAsRootPath: '/index.html',
  );
  pod.webServer.addRoute(routeStaticDirectory, '/*');

  // Start the server.
  await pod.start();
}
