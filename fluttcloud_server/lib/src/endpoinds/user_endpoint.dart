import 'package:fluttcloud_server/common_imports.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';

class UserEndpoint extends Endpoint {
  Future<bool> deleteMyUserProfile(Session session, [int? userId]) async {
    final user = await session.getRequestUser();
    if (user == null) throw const UserNotFoundException();

    final deleteUserId = userId ?? user.id;
    if (!user.isAdmin) {
      if (deleteUserId != user.id) {
        throw const UnAuthorizedException();
      }
    }

    final deleteUser = await Users.findUserByUserId(session, deleteUserId!);
    if (deleteUser == null) throw const UserNotFoundException();

    // Delete the user and all related data
    await UserInfo.db.deleteRow(session, deleteUser);
    await EmailAuth.db.deleteWhere(
      session,
      where: (auth) => auth.userId.equals(deleteUserId),
    );
    await UserImage.db.deleteWhere(
      session,
      where: (image) => image.userId.equals(deleteUserId),
    );

    // Remove cache for the user
    await Users.invalidateCacheForUser(session, deleteUserId);

    return true;
  }
}
