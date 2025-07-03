// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:fluttcloud_flutter/src/features/home_tabs/home_tabs.dart'
    deferred as _i1;
import 'package:fluttcloud_flutter/src/features/login/view/login_screen.dart'
    deferred as _i2;
import 'package:fluttcloud_flutter/src/features/profile/view/profile_screen.dart'
    deferred as _i3;
import 'package:flutter/material.dart' as _i5;

/// generated route for
/// [_i1.HomeTabsScreen]
class HomeTabsRoute extends _i4.PageRouteInfo<void> {
  const HomeTabsRoute({List<_i4.PageRouteInfo>? children})
    : super(HomeTabsRoute.name, initialChildren: children);

  static const String name = 'HomeTabsRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return _i4.DeferredWidget(_i1.loadLibrary, () => _i1.HomeTabsScreen());
    },
  );
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i4.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    required void Function() onLoginSuccess,
    _i5.Key? key,
    List<_i4.PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(onLoginSuccess: onLoginSuccess, key: key),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>();
      return _i4.DeferredWidget(
        _i2.loadLibrary,
        () =>
            _i2.LoginScreen(onLoginSuccess: args.onLoginSuccess, key: args.key),
      );
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({required this.onLoginSuccess, this.key});

  final void Function() onLoginSuccess;

  final _i5.Key? key;

  @override
  String toString() {
    return 'LoginRouteArgs{onLoginSuccess: $onLoginSuccess, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i3.ProfileScreen]
class ProfileRoute extends _i4.PageRouteInfo<void> {
  const ProfileRoute({List<_i4.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return _i4.DeferredWidget(_i3.loadLibrary, () => _i3.ProfileScreen());
    },
  );
}
