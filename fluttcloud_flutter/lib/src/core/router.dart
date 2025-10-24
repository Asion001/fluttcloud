import 'dart:async';
import 'dart:ui';

import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

@AutoRouterConfig(
  deferredLoading: true,
  replaceInRouteName: 'Dialog|Page|Screen,Route',
)
@Singleton(order: 0)
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(
        page: HomeTabsRoute.page,
        path: '/',
        initial: true,
        guards: _privateGuards,
      ),
      AutoRoute(
        page: ProfileRoute.page,
        path: '/profile',
        guards: _privateGuards,
      ),
      AutoRoute(
        page: ShareLinksRoute.page,
        path: '/share-links',
        guards: _privateGuards,
      ),
      AutoRoute(
        page: UserManagementRoute.page,
        path: '/user-management',
        guards: _privateGuards,
      ),
      AutoRoute(page: LoginRoute.page, path: '/login'),
      AutoRoute(page: ServerPickerRoute.page, path: '/server-config'),
    ];
  }

  List<AutoRouteGuard> get _privateGuards => [ServerConfigGuard(), AuthGuard()];

  static AppRouter get I => getIt<AppRouter>();

  @override
  RouteType get defaultRouteType =>
      const RouteType.adaptive(enablePredictiveBackGesture: true);

  Future<Uri> deepLinkTransformer(Uri uri) async {
    if (uri.path != '/') {
      // Make home screen behind any page from deep link
      Future.delayed(Duration.zero, () => pushPath(uri.path));
    }
    return Uri(path: '/');
  }
}

class BlurDialogRoute<R> extends CustomRoute<R> {
  BlurDialogRoute({
    required super.page,
    super.path,
    super.children,
    super.allowSnapshotting,
    super.barrierDismissible,
    super.barrierLabel,
    super.customRouteBuilder,
    super.duration,
    super.fullMatch,
    super.guards,
    super.initial,
    super.keepHistory,
    super.maintainState,
    super.meta,
    super.restorationId,
    super.reverseDuration,
    super.title,
    super.usesPathAsKey,
  }) : super(
         transitionsBuilder: blurIn,
         barrierColor: Colors.black.withValues(alpha: .3),
         opaque: false,
         fullscreenDialog: true,
       );

  static Widget blurIn(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final sigma = animation.value * 2;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: child,
        );
      },
    );
  }
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isSignedIn = Serverpod.I.isSignedIn;
    if (isSignedIn) {
      // if user is authenticated we continue
      resolver.next();
    } else {
      // we redirect the user to our login page
      // tip: use resolver.redirectUntil to have the redirected route
      // automatically removed from the stack when the resolver is completed
      resolver.redirectUntil(LoginRoute(onLoginSuccess: resolver.next));
    }
  }
}

class ServerConfigGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isServerUrlSet = getIt<ServerConfigController>().isServerUrlSet;
    if (isServerUrlSet) {
      // if user is authenticated we continue
      resolver.next();
    } else {
      // we redirect the user to our login page
      // tip: use resolver.redirectUntil to have the redirected route
      // automatically removed from the stack when the resolver is completed
      resolver.redirectUntil(
        ServerPickerRoute(onServerUrlChanged: resolver.next),
      );
    }
  }
}
