// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../features/file_download/controllers/file_download_controller.dart'
    as _i632;
import '../features/file_list/controllers/file_list_controller.dart' as _i677;
import '../features/server_config/controllers/server_config_controller.dart'
    as _i138;
import '../features/share_links/controller/share_links_controller.dart'
    as _i322;
import 'controllers/storage.dart' as _i770;
import 'controllers/toast_controller.dart' as _i278;
import 'router.dart' as _i216;
import 'serverpod_client.dart' as _i193;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i193.Serverpod>(() => _i193.Serverpod());
    gh.singleton<_i278.ToastController>(() => _i278.ToastController());
    gh.singleton<_i770.Storage>(() => _i770.Storage());
    gh.singleton<_i216.AppRouter>(() => _i216.AppRouter());
    gh.singleton<_i677.FileListController>(() => _i677.FileListController());
    await gh.singletonAsync<_i138.ServerConfigController>(() {
      final i = _i138.ServerConfigController();
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.singleton<_i632.FileDownloadController>(
      () => _i632.FileDownloadController(),
    );
    gh.singleton<_i322.ShareLinksController>(
      () => _i322.ShareLinksController(),
    );
    return this;
  }
}
