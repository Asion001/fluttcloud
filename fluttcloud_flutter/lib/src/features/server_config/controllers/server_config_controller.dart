import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

@singleton
class ServerConfigController extends ChangeNotifier {
  String? _serverUrl;

  String? get serverUrl {
    if (_serverUrl?.endsWith('/') ?? true) {
      return _serverUrl;
    }
    return '$_serverUrl/';
  }

  bool get isServerUrlSet => !_serverUrl.isEmptyOrNull;

  void setServerUrl(String url) {
    _serverUrl = url;

    notifyListeners();

    Storage.I.put(StorageKey.serverUrl.name, serverUrl!);
    getIt<Serverpod>().init(Uri.parse(serverUrl!));
  }

  Future<void> deleteConfig() async {
    await Storage.I.rm(StorageKey.serverUrl.name);
    _serverUrl = null;
    notifyListeners();

    await AppRouter.I.replaceAll([const HomeTabsRoute()]);
  }

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final savedUrl = await Storage.I.get(StorageKey.serverUrl.name);
    _serverUrl = savedUrl?.toString();

    // Init Serverpod after getting server url
    if (isServerUrlSet) {
      await getIt<Serverpod>().init(Uri.parse(serverUrl!));
    }

    notifyListeners();
  }
}
