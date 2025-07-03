import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';

@RoutePage()
class LoginScreen extends WatchingWidget {
  const LoginScreen({required this.onLoginSuccess, super.key});
  final void Function() onLoginSuccess;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.login_screen_title.tr())),
      body: SignInWithEmailButton(
        caller: Serverpod.I.client.modules.auth,
        onSignedIn: onLoginSuccess,
      ).center(),
    );
  }
}
