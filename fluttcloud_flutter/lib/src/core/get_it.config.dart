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
    await gh.factoryAsync<_i193.Serverpod>(() {
      final i = _i193.Serverpod();
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.singleton<_i278.ToastController>(() => _i278.ToastController());
    gh.singleton<_i216.AppRouter>(() => _i216.AppRouter());
    return this;
  }
}
