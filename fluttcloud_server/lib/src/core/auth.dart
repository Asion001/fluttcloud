import 'package:fluttcloud_server/common_imports.dart';
import 'package:fluttcloud_server/src/core/env.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

Future<void> initializeAuth() async {
  final authConfig = AuthConfig(
    sendValidationEmail: (session, email, validationCode) async {
      final text = '$email validation code: $validationCode';
      session.log(
        text,
        level: LogLevel.info,
      );
      return true;
    },
    sendPasswordResetEmail: (session, userInfo, validationCode) async {
      final text =
          '${userInfo.email} password reset validation code: $validationCode';
      session.log(
        text,
        level: LogLevel.info,
      );
      return true;
    },
    onUserCreated: (session, userInfo) async {
      // Set first user as admin if no other users exist.
      final usersCount = await session.db.count<UserInfo>();
      if (usersCount == 1) {
        await userInfo.updateScopes(session, {...userInfo.scopes, Scope.admin});
        session.log(
          'User ${userInfo.userName} (${userInfo.email}) is set as admin.',
          level: LogLevel.info,
        );
      }

      // Ensure the user has a full name set.
      // If not, set it to the username.
      if (userInfo.fullName.isEmptyOrNull) {
        await userInfo.changeFullName(session, userInfo.userName ?? '');
      }
    },
    onUserWillBeCreated: (session, userInfo, method) async {
      // Allow only admins to register
      final usersCount = await session.db.count<UserInfo>();
      if (usersCount >= 1 && !allowRegistration) {
        session.log(
          'User registration is disabled. User ${userInfo.userName} '
          '(${userInfo.email}) cannot be created.',
          level: LogLevel.warning,
        );
        return false;
      }

      return true;
    },
  );
  AuthConfig.set(authConfig);
}
