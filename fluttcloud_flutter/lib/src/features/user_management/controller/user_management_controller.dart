import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/fluttcloud_flutter.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

@singleton
class UserManagementController extends ChangeNotifier {
  UserManagementController();

  static UserManagementController get I => getIt<UserManagementController>();

  late PagingController<int, UserInfoWithFolders> pagingController;

  static const int _pageSize = 20;

  bool get isLoading =>
      pagingController.value.status == PagingStatus.loadingFirstPage;

  void init() {
    pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // Fetch paginated users from server
      final result = await Serverpod.I.client.admin.listUsers(
        page: pageKey,
        pageSize: _pageSize,
      );

      final isLastPage = !result.hasNextPage;
      if (isLastPage) {
        pagingController.appendLastPage(result.users);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(result.users, nextPageKey);
      }

      notifyListeners();
    } catch (error) {
      pagingController.error = error;
      await ToastController.I.show(
        '${LocaleKeys.error.tr()}: $error',
      );
    }
  }

  Future<void> loadUsers() async {
    pagingController.refresh();
  }

  void clear() {
    pagingController.dispose();
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
