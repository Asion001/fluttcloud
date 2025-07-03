// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(useConstantCase: true)
final class Env {
  @EnviedField(defaultValue: 'http://localhost:8080/')
  static Uri serverUrl = _Env.serverUrl;
}
