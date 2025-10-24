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
import 'package:fluttcloud_client/src/protocol/fs_entry.dart' as _i3;
import 'package:fluttcloud_client/src/protocol/shared_link_with_url.dart'
    as _i4;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i5;
import 'protocol.dart' as _i6;

/// {@category Endpoint}
class EndpointFiles extends _i1.EndpointRef {
  EndpointFiles(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'files';

  _i2.Stream<_i3.FsEntry> list({String? serverFolderPath}) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i3.FsEntry>, _i3.FsEntry>(
        'files',
        'list',
        {'serverFolderPath': serverFolderPath},
        {},
      );

  _i2.Future<Uri> getPrivateUri(String serverFilePath) =>
      caller.callServerEndpoint<Uri>(
        'files',
        'getPrivateUri',
        {'serverFilePath': serverFilePath},
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

  _i2.Future<List<_i4.SharedLinkWithUrl>> list({int? userId}) =>
      caller.callServerEndpoint<List<_i4.SharedLinkWithUrl>>(
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
    auth = _i5.Caller(client);
  }

  late final _i5.Caller auth;
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
          _i6.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    files = EndpointFiles(this);
    links = EndpointLinks(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointFiles files;

  late final EndpointLinks links;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'files': files,
        'links': links,
        'user': user,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
