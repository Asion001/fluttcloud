import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

@RoutePage()
class UserManagementScreen extends WatchingWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = watchIt<UserManagementController>();
    callOnce((context) => controller.init(), dispose: controller.clear);

    return MaxSizeContainer(
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.user_management_title.tr()),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _createUser(context, controller),
          icon: const Icon(Icons.person_add),
          label: Text(LocaleKeys.user_management_create_user.tr()),
        ),
        body: PagedListView<int, UserInfoWithFolders>(
          padding: 16.all,
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<UserInfoWithFolders>(
            itemBuilder: (context, user, index) => _UserListItem(
              user: user,
              onEdit: () => _editUser(context, controller, user),
              onDelete: () => _deleteUser(context, controller, user),
            ),
            firstPageErrorIndicatorBuilder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${LocaleKeys.error.tr()}: '
                    '${controller.pagingController.error}',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.pagingController.refresh,
                    child: Text(LocaleKeys.retry.tr()),
                  ),
                ],
              ),
            ),
            noItemsFoundIndicatorBuilder: (context) => Center(
              child: Text(LocaleKeys.user_management_no_users.tr()),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteUser(
    BuildContext context,
    UserManagementController controller,
    UserInfoWithFolders user,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.delete.tr()),
        content: Text(
          LocaleKeys.user_management_delete_user_confirm.tr(args: [user.email]),
        ),
        actions: [
          TextButton(
            onPressed: () async => Navigator.of(context).pop(false),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          FilledButton(
            onPressed: () async => Navigator.of(context).pop(true),
            child: Text(LocaleKeys.delete.tr()),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await controller.deleteUser(user);
    }
  }

  Future<void> _editUser(
    BuildContext context,
    UserManagementController controller,
    UserInfoWithFolders user,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => _UserEditScreen(user: user),
      ),
    );

    if (result ?? false) {
      await controller.loadUsers();
    }
  }

  Future<void> _createUser(
    BuildContext context,
    UserManagementController controller,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const _UserEditScreen(),
      ),
    );

    if (result ?? false) {
      await controller.loadUsers();
    }
  }
}

class _UserListItem extends StatelessWidget {
  const _UserListItem({
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  final UserInfoWithFolders user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            user.userName?.substring(0, 1).toUpperCase() ??
                user.email.substring(0, 1).toUpperCase(),
          ),
        ),
        title: Row(
          children: [
            Text(user.userName ?? user.email),
            if (user.isAdmin) ...[
              const SizedBox(width: 8),
              Chip(
                label: Text(
                  LocaleKeys.user_management_admin_badge.tr(),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            const SizedBox(height: 4),
            Text(
              user.isAdmin
                  ? LocaleKeys.user_management_all_folders.tr()
                  : LocaleKeys.user_management_folders.plural(
                      user.folderPaths.length,
                    ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: PopupMenuButton<void>(
          itemBuilder: (context) => [
            PopupMenuItem<void>(
              onTap: onEdit,
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  const SizedBox(width: 8),
                  Text(LocaleKeys.edit.tr()),
                ],
              ),
            ),
            PopupMenuItem<void>(
              onTap: onDelete,
              child: Row(
                children: [
                  const Icon(Icons.delete),
                  const SizedBox(width: 8),
                  Text(LocaleKeys.delete.tr()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserEditScreen extends StatefulWidget {
  const _UserEditScreen({this.user});

  final UserInfoWithFolders? user;

  @override
  State<_UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<_UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserManagementController _controller = UserManagementController.I;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  late bool _isAdmin;
  late List<String> _folderPaths;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _usernameController = TextEditingController(
      text: widget.user?.userName ?? '',
    );
    _fullNameController = TextEditingController(
      text: widget.user?.fullName ?? '',
    );
    _isAdmin = widget.user?.isAdmin ?? false;
    _folderPaths = List.from(widget.user?.folderPaths ?? []);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    var success = false;
    try {
      if (widget.user == null) {
        // Create new user
        success = await _controller.createUser(
          email: _emailController.text,
          userName: _usernameController.text,
          isAdmin: _isAdmin,
          fullName: _fullNameController.text.isEmpty
              ? null
              : _fullNameController.text,
          folderPaths: _folderPaths,
        );
      } else {
        // Update existing user
        success = await _controller.updateUser(
          userId: widget.user!.userId,
          userName: _usernameController.text,
          fullName: _fullNameController.text.isEmpty
              ? null
              : _fullNameController.text,
          isAdmin: _isAdmin,
          folderPaths: _folderPaths,
        );
      }

      if (success && mounted) {
        Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _addFolder() {
    showDialog<void>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(LocaleKeys.user_management_add_folder.tr()),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: LocaleKeys.user_management_folder_path.tr(),
              hintText: LocaleKeys.user_management_folder_path_hint.tr(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(LocaleKeys.cancel.tr()),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _folderPaths.add(controller.text);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text(LocaleKeys.add.tr()),
            ),
          ],
        );
      },
    );
  }

  void _removeFolder(int index) {
    setState(() {
      _folderPaths.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? LocaleKeys.user_management_edit_user.tr()
              : LocaleKeys.user_management_create_user.tr(),
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              onPressed: _save,
              icon: const Icon(Icons.check),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: 16.all,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: LocaleKeys.user_management_email.tr(),
                border: const OutlineInputBorder(),
              ),
              enabled: !isEdit,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.user_management_email_required.tr();
                }
                if (!value.contains('@')) {
                  return LocaleKeys.user_management_invalid_email.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: LocaleKeys.user_management_username.tr(),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.user_management_username_required.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: LocaleKeys.user_management_full_name.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(LocaleKeys.user_management_is_admin.tr()),
              value: _isAdmin,
              onChanged: (value) {
                setState(() => _isAdmin = value);
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.user_management_folder_access.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                FilledButton.icon(
                  onPressed: _isAdmin ? null : _addFolder,
                  icon: const Icon(Icons.add),
                  label: Text(LocaleKeys.user_management_add_folder.tr()),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_isAdmin)
              Card(
                child: Padding(
                  padding: 16.all,
                  child: Text(
                    LocaleKeys.user_management_all_folders.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            else if (_folderPaths.isEmpty)
              Card(
                child: Padding(
                  padding: 16.all,
                  child: Text(
                    LocaleKeys.user_management_no_folder_access.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            else
              ..._folderPaths.asMap().entries.map((entry) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.folder),
                    title: Text(entry.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeFolder(entry.key),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
