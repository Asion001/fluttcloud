// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:fluttcloud_flutter/src/features/home_tabs/home_tabs.dart'
    deferred as _i1;

/// generated route for
/// [_i1.HomeTabsScreen]
class HomeTabsRoute extends _i2.PageRouteInfo<void> {
  const HomeTabsRoute({List<_i2.PageRouteInfo>? children})
    : super(HomeTabsRoute.name, initialChildren: children);

  static const String name = 'HomeTabsRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      return _i2.DeferredWidget(_i1.loadLibrary, () => _i1.HomeTabsScreen());
    },
  );
}
