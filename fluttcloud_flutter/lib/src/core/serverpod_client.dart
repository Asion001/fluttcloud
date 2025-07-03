import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

@injectable
class Serverpod {
  late final Client client;
  late SessionManager sessionManager;

  static Serverpod get I => getIt<Serverpod>();

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    client = Client(
      Env.serverUrl.toString(),
      authenticationKeyManager: FlutterAuthenticationKeyManager(),
    )..connectivityMonitor = FlutterConnectivityMonitor();

    // The session manager keeps track of the signed-in state of the user. You
    // can query it to see if the user is currently signed in and get
    // information about the user.
    sessionManager = SessionManager(caller: client.modules.auth);

    await sessionManager.initialize();

    sessionManager.addListener(() {
      if (!sessionManager.isSignedIn) {
        AppRouter.I.replaceAll([const HomeTabsRoute()]);
      }
    });
  }
}
