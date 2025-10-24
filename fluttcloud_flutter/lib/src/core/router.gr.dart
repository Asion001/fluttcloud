// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:fluttcloud_flutter/src/features/home_tabs/home_tabs.dart'
    deferred as _i1;
import 'package:fluttcloud_flutter/src/features/login/view/login_screen.dart'
    deferred as _i2;
import 'package:fluttcloud_flutter/src/features/profile/view/profile_screen.dart'
    deferred as _i3;
import 'package:fluttcloud_flutter/src/features/server_config/view/server_picker_screen.dart'
    deferred as _i4;
import 'package:fluttcloud_flutter/src/features/share_links/view/share_links_screen.dart'
    deferred as _i5;
import 'package:flutter/material.dart' as _i7;

/// generated route for
/// [_i1.HomeTabsScreen]
class HomeTabsRoute extends _i6.PageRouteInfo<void> {
  const HomeTabsRoute({List<_i6.PageRouteInfo>? children})
    : super(HomeTabsRoute.name, initialChildren: children);

  static const String name = 'HomeTabsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return _i6.DeferredWidget(_i1.loadLibrary, () => _i1.HomeTabsScreen());
    },
  );
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i6.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    required void Function() onLoginSuccess,
    _i7.Key? key,
    List<_i6.PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(onLoginSuccess: onLoginSuccess, key: key),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>();
      return _i6.DeferredWidget(
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

  final _i7.Key? key;

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
class ProfileRoute extends _i6.PageRouteInfo<void> {
  const ProfileRoute({List<_i6.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return _i6.DeferredWidget(_i3.loadLibrary, () => _i3.ProfileScreen());
    },
  );
}

/// generated route for
/// [_i4.ServerPickerScreen]
class ServerPickerRoute extends _i6.PageRouteInfo<ServerPickerRouteArgs> {
  ServerPickerRoute({
    _i7.Key? key,
    _i7.VoidCallback? onServerUrlChanged,
    List<_i6.PageRouteInfo>? children,
  }) : super(
         ServerPickerRoute.name,
         args: ServerPickerRouteArgs(
           key: key,
           onServerUrlChanged: onServerUrlChanged,
         ),
         initialChildren: children,
       );

  static const String name = 'ServerPickerRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ServerPickerRouteArgs>(
        orElse: () => const ServerPickerRouteArgs(),
      );
      return _i6.DeferredWidget(
        _i4.loadLibrary,
        () => _i4.ServerPickerScreen(
          key: args.key,
          onServerUrlChanged: args.onServerUrlChanged,
        ),
      );
    },
  );
}

class ServerPickerRouteArgs {
  const ServerPickerRouteArgs({this.key, this.onServerUrlChanged});

  final _i7.Key? key;

  final _i7.VoidCallback? onServerUrlChanged;

  @override
  String toString() {
    return 'ServerPickerRouteArgs{key: $key, onServerUrlChanged: $onServerUrlChanged}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerPickerRouteArgs) return false;
    return key == other.key && onServerUrlChanged == other.onServerUrlChanged;
  }

  @override
  int get hashCode => key.hashCode ^ onServerUrlChanged.hashCode;
}

/// generated route for
/// [_i5.ShareLinksScreen]
class ShareLinksRoute extends _i6.PageRouteInfo<void> {
  const ShareLinksRoute({List<_i6.PageRouteInfo>? children})
    : super(ShareLinksRoute.name, initialChildren: children);

  static const String name = 'ShareLinksRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return _i6.DeferredWidget(_i5.loadLibrary, () => _i5.ShareLinksScreen());
    },
  );
}
