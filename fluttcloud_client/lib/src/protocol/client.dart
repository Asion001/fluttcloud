/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:fluttcloud_client/src/protocol/user_info_with_folders.dart'
    as _i3;
import 'package:fluttcloud_client/src/protocol/fs_entry.dart' as _i4;
import 'package:fluttcloud_client/src/protocol/fs_entry_type.dart' as _i5;
import 'package:fluttcloud_client/src/protocol/shared_link_with_url.dart'
    as _i6;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i7;
import 'protocol.dart' as _i8;

/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  /// Lists all users with their folder access permissions
  /// Admin only
  _i2.Future<List<_i3.UserInfoWithFolders>> listUsers() =>
      caller.callServerEndpoint<List<_i3.UserInfoWithFolders>>(
        'admin',
        'listUsers',
        {},
      );

  /// Creates a new user with email and password
  /// Admin only
  _i2.Future<_i3.UserInfoWithFolders> createUser({
    required String email,
    required String userName,
    required bool isAdmin,
    String? fullName,
    required List<String> folderPaths,
  }) =>
      caller.callServerEndpoint<_i3.UserInfoWithFolders>(
        'admin',
        'createUser',
        {
          'email': email,
          'userName': userName,
          'isAdmin': isAdmin,
          'fullName': fullName,
          'folderPaths': folderPaths,
        },
      );

  /// Updates user information
  /// Admin only
  _i2.Future<_i3.UserInfoWithFolders> updateUser({
    required int userId,
    String? userName,
    String? fullName,
    bool? isAdmin,
    List<String>? folderPaths,
  }) =>
      caller.callServerEndpoint<_i3.UserInfoWithFolders>(
        'admin',
        'updateUser',
        {
          'userId': userId,
          'userName': userName,
          'fullName': fullName,
          'isAdmin': isAdmin,
          'folderPaths': folderPaths,
        },
      );

  /// Initiates password reset for user
  /// Admin only - sends validation email to user
  _i2.Future<void> initiatePasswordReset({required int userId}) =>
      caller.callServerEndpoint<void>(
        'admin',
        'initiatePasswordReset',
        {'userId': userId},
      );

  /// Deletes a user (admin only, cannot delete self)
  _i2.Future<void> deleteUser(int userId) => caller.callServerEndpoint<void>(
        'admin',
        'deleteUser',
        {'userId': userId},
      );

  /// Gets allowed folder paths for the current user
  /// Returns all paths if user is admin, otherwise returns
  /// user's allowed folders
  _i2.Future<List<String>> getAllowedFolders() =>
      caller.callServerEndpoint<List<String>>(
        'admin',
        'getAllowedFolders',
        {},
      );
}

/// {@category Endpoint}
class EndpointFiles extends _i1.EndpointRef {
  EndpointFiles(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'files';

  _i2.Stream<_i4.FsEntry> list({
    String? serverFolderPath,
    _i5.FsEntryType? filterByType,
  }) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i4.FsEntry>, _i4.FsEntry>(
        'files',
        'list',
        {
          'serverFolderPath': serverFolderPath,
          'filterByType': filterByType,
        },
        {},
      );

  _i2.Future<Uri> getPrivateUri(String serverFilePath) =>
      caller.callServerEndpoint<Uri>(
        'files',
        'getPrivateUri',
        {'serverFilePath': serverFilePath},
      );

  _i2.Future<void> deleteFile(String serverFilePath) =>
      caller.callServerEndpoint<void>(
        'files',
        'deleteFile',
        {'serverFilePath': serverFilePath},
      );

  _i2.Future<void> copyFile(
    String sourceServerPath,
    String destinationServerPath,
  ) =>
      caller.callServerEndpoint<void>(
        'files',
        'copyFile',
        {
          'sourceServerPath': sourceServerPath,
          'destinationServerPath': destinationServerPath,
        },
      );

  _i2.Future<void> renameFile(
    String serverFilePath,
    String newName,
  ) =>
      caller.callServerEndpoint<void>(
        'files',
        'renameFile',
        {
          'serverFilePath': serverFilePath,
          'newName': newName,
        },
      );

  _i2.Future<void> moveFile(
    String sourceServerPath,
    String destinationServerPath,
  ) =>
      caller.callServerEndpoint<void>(
        'files',
        'moveFile',
        {
          'sourceServerPath': sourceServerPath,
          'destinationServerPath': destinationServerPath,
        },
      );
}

/// {@category Endpoint}
class EndpointLinks extends _i1.EndpointRef {
  EndpointLinks(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'links';

  /// Returns full share url
  _i2.Future<String> create({
    required String serverPath,
    DateTime? deleteAfter,
  }) =>
      caller.callServerEndpoint<String>(
        'links',
        'create',
        {
          'serverPath': serverPath,
          'deleteAfter': deleteAfter,
        },
      );

  _i2.Future<List<_i6.SharedLinkWithUrl>> list({int? userId}) =>
      caller.callServerEndpoint<List<_i6.SharedLinkWithUrl>>(
        'links',
        'list',
        {'userId': userId},
      );

  _i2.Future<void> update({
    required int linkId,
    required String serverPath,
    required DateTime? deleteAfter,
    required String? linkPrefix,
  }) =>
      caller.callServerEndpoint<void>(
        'links',
        'update',
        {
          'linkId': linkId,
          'serverPath': serverPath,
          'deleteAfter': deleteAfter,
          'linkPrefix': linkPrefix,
        },
      );

  _i2.Future<void> delete(int linkId) => caller.callServerEndpoint<void>(
        'links',
        'delete',
        {'linkId': linkId},
      );
}

/// {@category Endpoint}
class EndpointUser extends _i1.EndpointRef {
  EndpointUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  _i2.Future<bool> deleteMyUserProfile([int? userId]) =>
      caller.callServerEndpoint<bool>(
        'user',
        'deleteMyUserProfile',
        {'userId': userId},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i7.Caller(client);
  }

  late final _i7.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i8.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    admin = EndpointAdmin(this);
    files = EndpointFiles(this);
    links = EndpointLinks(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointAdmin admin;

  late final EndpointFiles files;

  late final EndpointLinks links;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'admin': admin,
        'files': files,
        'links': links,
        'user': user,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
