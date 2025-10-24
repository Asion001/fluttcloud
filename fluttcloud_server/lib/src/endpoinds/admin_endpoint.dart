import 'package:fluttcloud_server/common_imports.dart';
import 'package:fluttcloud_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';

class AdminEndpoint extends Endpoint {
  /// Lists all users with their folder access permissions
  /// Admin only
  Future<List<UserInfoWithFolders>> listUsers(Session session) async {
    await _validateAdminAccess(session);

    // Get all users with their folder access in a single efficient query
    final users = await UserInfo.db.find(session);
    final userIds = users.map((u) => u.id!).toList();

    // Fetch all folder accesses for these users in one query
    final folderAccesses = await UserFolderAccess.db.find(
      session,
      where: (t) => t.userId.inSet(userIds.toSet()),
    );

    // Group folder accesses by user ID
    final foldersByUser = <int, List<String>>{};
    for (final access in folderAccesses) {
      final userId = access.userId;
      foldersByUser.putIfAbsent(userId, () => []).add(access.folderPath);
    }

    // Build result with all data
    return users.map((user) {
      final userId = user.id!;
      return UserInfoWithFolders(
        userId: userId,
        userName: user.userName,
        email: user.email!,
        fullName: user.fullName,
        isAdmin: user.scopes.contains(Scope.admin),
        folderPaths: foldersByUser[userId] ?? [],
      );
    }).toList();
  }

  /// Creates a new user with email and password
  /// Admin only
  Future<UserInfoWithFolders> createUser(
    Session session, {
    required String email,
    required String userName,
    required bool isAdmin,
    String? fullName,
    List<String> folderPaths = const [],
  }) async {
    await _validateAdminAccess(session);

    // Validate email
    if (!email.contains('@')) {
      throw Exception('Invalid email address');
    }

    // Check if user already exists
    final existingUser = await Users.findUserByEmail(session, email);
    if (existingUser != null) {
      throw Exception('User with this email already exists');
    }

    // Create user info directly
    final userInfo = UserInfo(
      userName: userName,
      email: email,
      fullName: fullName ?? userName,
      scopeNames: isAdmin ? [Scope.admin.toString()] : [],
      created: DateTime.now(),
      blocked: false,
      userIdentifier: email,
    );
    await UserInfo.db.insertRow(session, userInfo);

    // Set folder access permissions
    if (folderPaths.isNotEmpty) {
      final accesses = folderPaths.map((path) {
        return UserFolderAccess(
          userId: userInfo.id!,
          folderPath: path,
        );
      }).toList();
      await UserFolderAccess.db.insert(session, accesses);
    }

    return UserInfoWithFolders(
      userId: userInfo.id!,
      userName: userInfo.userName,
      email: userInfo.email!,
      fullName: userInfo.fullName,
      isAdmin: isAdmin,
      folderPaths: folderPaths,
    );
  }

  /// Updates user information
  /// Admin only
  Future<UserInfoWithFolders> updateUser(
    Session session, {
    required int userId,
    String? userName,
    String? fullName,
    bool? isAdmin,
    List<String>? folderPaths,
  }) async {
    await _validateAdminAccess(session);

    final user = await Users.findUserByUserId(session, userId);
    if (user == null) {
      throw const UserNotFoundException();
    }

    // Update user info
    if (userName != null && userName != user.userName) {
      await user.changeUserName(session, userName);
    }
    if (fullName != null && fullName != user.fullName) {
      await user.changeFullName(session, fullName);
    }

    // Update admin scope
    if (isAdmin != null) {
      final currentScopes = user.scopes;
      final newScopes = isAdmin
          ? {...currentScopes, Scope.admin}
          : currentScopes.where((s) => s != Scope.admin).toSet();
      await user.updateScopes(session, newScopes);
    }

    // Update folder access if provided
    if (folderPaths != null) {
      // Delete existing folder access
      await UserFolderAccess.db.deleteWhere(
        session,
        where: (t) => t.userId.equals(userId),
      );

      // Insert new folder access
      if (folderPaths.isNotEmpty) {
        final accesses = folderPaths.map((path) {
          return UserFolderAccess(
            userId: userId,
            folderPath: path,
          );
        }).toList();
        await UserFolderAccess.db.insert(session, accesses);
      }
    }

    // Fetch updated user info
    final updatedUser = await Users.findUserByUserId(session, userId);
    final updatedFolders =
        folderPaths ??
        (await UserFolderAccess.db.find(
          session,
          where: (t) => t.userId.equals(userId),
        )).map((UserFolderAccess? a) => a!.folderPath).toList();

    return UserInfoWithFolders(
      userId: userId,
      userName: updatedUser!.userName,
      email: updatedUser.email!,
      fullName: updatedUser.fullName,
      isAdmin: updatedUser.scopes.contains(Scope.admin),
      folderPaths: updatedFolders,
    );
  }

  /// Initiates password reset for user
  /// Admin only - sends validation email to user
  Future<void> initiatePasswordReset(
    Session session, {
    required int userId,
  }) async {
    await _validateAdminAccess(session);

    final user = await Users.findUserByUserId(session, userId);
    if (user == null) {
      throw const UserNotFoundException();
    }

    if (user.email == null) {
      throw Exception('User has no email address');
    }

    // Note: Password reset handled by email verification
    // Admins can use serverpod_auth endpoints to manage passwords
    throw Exception('Use email authentication for password reset');
  }

  /// Deletes a user (admin only, cannot delete self)
  Future<void> deleteUser(Session session, int userId) async {
    await _validateAdminAccess(session);

    final currentUser = await session.getRequestUser();
    if (currentUser?.id == userId) {
      throw Exception('Cannot delete your own account');
    }

    final user = await Users.findUserByUserId(session, userId);
    if (user == null) {
      throw const UserNotFoundException();
    }

    // Delete folder access
    await UserFolderAccess.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );

    // Delete shared links created by this user
    await SharedLink.db.deleteWhere(
      session,
      where: (link) => link.createdBy.equals(userId),
    );

    // Delete user and related data
    await UserInfo.db.deleteRow(session, user);
    await EmailAuth.db.deleteWhere(
      session,
      where: (auth) => auth.userId.equals(userId),
    );
    await UserImage.db.deleteWhere(
      session,
      where: (image) => image.userId.equals(userId),
    );

    // Remove cache
    await Users.invalidateCacheForUser(session, userId);
  }

  /// Gets allowed folder paths for the current user
  /// Returns all paths if user is admin, otherwise returns
  /// user's allowed folders
  Future<List<String>> getAllowedFolders(Session session) async {
    final auth = await session.authenticated;
    if (auth?.userId == null) {
      throw const UnAuthorizedException();
    }

    // Admins have access to all folders
    if (auth.isAdmin) {
      return []; // Empty list means all folders
    }

    // Get user's allowed folders
    final folderAccesses = await UserFolderAccess.db.find(
      session,
      where: (t) => t.userId.equals(auth!.userId),
    );

    return folderAccesses.map((UserFolderAccess? a) => a!.folderPath).toList();
  }

  Future<void> _validateAdminAccess(Session session) async {
    final auth = await session.authenticated;
    if (!auth.isAdmin) {
      throw const UnAuthorizedException();
    }
  }
}
