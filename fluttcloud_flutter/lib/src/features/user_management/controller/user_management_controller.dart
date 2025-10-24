import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/fluttcloud_flutter.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

@singleton
class UserManagementController extends ChangeNotifier {
  static UserManagementController get I => getIt<UserManagementController>();

  final PagingController<int, UserInfoWithFolders> pagingController =
      PagingController(firstPageKey: 0);

  static const int _pageSize = 20;
  List<UserInfoWithFolders> _allUsers = [];

  List<UserInfoWithFolders> get users => _allUsers;
  bool get isLoading => pagingController.value.status == PagingStatus.loadingFirstPage;

  UserManagementController() {
    pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // Load all users from server (we'll paginate in memory)
      if (pageKey == 0) {
        _allUsers = await Serverpod.I.client.admin.listUsers();
      }

      final startIndex = pageKey * _pageSize;
      final endIndex = startIndex + _pageSize;

      if (startIndex >= _allUsers.length) {
        pagingController.appendLastPage([]);
        return;
      }

      final newItems = _allUsers.sublist(
        startIndex,
        endIndex > _allUsers.length ? _allUsers.length : endIndex,
      );

      final isLastPage = endIndex >= _allUsers.length;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
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

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
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
