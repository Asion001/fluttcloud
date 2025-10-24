import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/fluttcloud_flutter.dart';

@singleton
class UserManagementController {
  static UserManagementController get I => getIt<UserManagementController>();

  List<UserInfoWithFolders>? _users;
  bool _isLoading = false;

  List<UserInfoWithFolders>? get users => _users;
  bool get isLoading => _isLoading;

  Future<void> loadUsers() async {
    _isLoading = true;

    try {
      _users = await Serverpod.I.client.admin.listUsers();
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      await ToastController.I.show(
        '${LocaleKeys.error.tr()}: $e',
      );
      rethrow;
    }
  }

  Future<bool> deleteUser(UserInfoWithFolders user) async {
    try {
      await Serverpod.I.client.admin.deleteUser(user.userId);
      await ToastController.I.show(
        LocaleKeys.user_management_user_deleted.tr(),
        type: ToastType.success,
      );
      await loadUsers(); // Refresh the list
      return true;
    } catch (e) {
      await ToastController.I.show(
        '${LocaleKeys.error.tr()}: $e',
      );
      return false;
    }
  }

  Future<bool> createUser({
    required String email,
    required String userName,
    required bool isAdmin,
    required List<String> folderPaths,
    String? fullName,
  }) async {
    try {
      await Serverpod.I.client.admin.createUser(
        email: email,
        userName: userName,
        isAdmin: isAdmin,
        fullName: fullName,
        folderPaths: folderPaths,
      );
      await ToastController.I.show(
        LocaleKeys.user_management_user_created.tr(),
        type: ToastType.success,
      );
      await loadUsers(); // Refresh the list
      return true;
    } catch (e) {
      await ToastController.I.show(
        '${LocaleKeys.error.tr()}: $e',
      );
      return false;
    }
  }

  Future<bool> updateUser({
    required int userId,
    required String userName,
    required bool isAdmin,
    required List<String> folderPaths,
    String? fullName,
  }) async {
    try {
      await Serverpod.I.client.admin.updateUser(
        userId: userId,
        userName: userName,
        fullName: fullName,
        isAdmin: isAdmin,
        folderPaths: folderPaths,
      );
      await ToastController.I.show(
        LocaleKeys.user_management_user_updated.tr(),
        type: ToastType.success,
      );
      await loadUsers(); // Refresh the list
      return true;
    } catch (e) {
      await ToastController.I.show(
        '${LocaleKeys.error.tr()}: $e',
      );
      return false;
    }
  }
}
