import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:package_info_plus/package_info_plus.dart';

class AppInit {
  static Future<void> init() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // Init localization
    await EasyLocalization.ensureInitialized();

    AppInit.packageInfo = await PackageInfo.fromPlatform();

    // ignore: prefer_const_constructors because it`s throw error during build
    setUrlStrategy(PathUrlStrategy());

    await configureDependencies();

    fvp.registerWith();

    logger.i(await getInitInfo());
  }

  static Future<void> buildInit() async {
    // Your init steps

    FlutterNativeSplash.remove();
  }

  static Future<String> getInitInfo() async {
    final parameters = {
      'Version': packageInfo.version,
      'Build number': packageInfo.buildNumber,
      if (kIsWasm || kIsWeb) 'WASM': kIsWasm,
    };

    final result = parameters.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\n');
    return result;
  }

  static late PackageInfo packageInfo;
}
