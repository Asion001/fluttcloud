import 'package:fluttcloud_server/common_imports.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

Future<void> initializeAuth() async {
  final authConfig = AuthConfig(
    sendValidationEmail: (session, email, validationCode) async {
      session.log(
        '$email validation code: $validationCode',
        level: LogLevel.info,
      );
      return true;
    },
    sendPasswordResetEmail: (session, userInfo, validationCode) async {
      session.log(
        '${userInfo.email} password reset validation code: $validationCode',
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
  );
  AuthConfig.set(authConfig);
}
