import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

@singleton
class Serverpod {
  Client? _client;
  SessionManager? _sessionManager;

  Client get client => _client!;
  SessionManager get sessionManager => _sessionManager!;

  static Serverpod get I => getIt<Serverpod>();

  bool get isSignedIn => _sessionManager?.isSignedIn ?? false;

  Future<void> logout() async {
    try {
      await _sessionManager?.signOutDevice();
    } catch (_) {}
    await _sessionManager?.keyManager.remove();
    _sessionManager?.dispose();
    _sessionManager = null;

    _client?.close();
    _client = null;

    await getIt<ServerConfigController>().deleteConfig();
    await AppRouter.I.replaceAll([const HomeTabsRoute()]);
  }

  Future<void> init(Uri serverUrl) async {
    _client?.close();

    final url = serverUrl.toString().endsWith('/')
        ? serverUrl.toString()
        : '$serverUrl/';
    _client = Client(
      url,
      authenticationKeyManager: FlutterAuthenticationKeyManager(),
    )..connectivityMonitor = FlutterConnectivityMonitor();

    // The session manager keeps track of the signed-in state of the user. You
    // can query it to see if the user is currently signed in and get
    // information about the user.
    await _sessionManager?.signOutDevice();
    _sessionManager?.dispose();
    _sessionManager = SessionManager(caller: _client!.modules.auth);

    await sessionManager.initialize();

    sessionManager.addListener(() {
      if (!isSignedIn) {
        AppRouter.I.replaceAll([const HomeTabsRoute()]);
      }
    });
  }
}
