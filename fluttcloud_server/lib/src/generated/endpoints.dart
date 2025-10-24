/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoinds/files_endpoint.dart' as _i2;
import '../endpoinds/links_endpoint.dart' as _i3;
import '../endpoinds/user_endpoint.dart' as _i4;
import 'package:fluttcloud_server/src/generated/fs_entry_type.dart' as _i5;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i6;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'files': _i2.FilesEndpoint()
        ..initialize(
          server,
          'files',
          null,
        ),
      'links': _i3.LinksEndpoint()
        ..initialize(
          server,
          'links',
          null,
        ),
      'user': _i4.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
    connectors['files'] = _i1.EndpointConnector(
      name: 'files',
      endpoint: endpoints['files']!,
      methodConnectors: {
        'getPrivateUri': _i1.MethodConnector(
          name: 'getPrivateUri',
          params: {
            'serverFilePath': _i1.ParameterDescription(
              name: 'serverFilePath',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['files'] as _i2.FilesEndpoint).getPrivateUri(
            session,
            params['serverFilePath'],
          ),
        ),
        'deleteFile': _i1.MethodConnector(
          name: 'deleteFile',
          params: {
            'serverFilePath': _i1.ParameterDescription(
              name: 'serverFilePath',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['files'] as _i2.FilesEndpoint).deleteFile(
            session,
            params['serverFilePath'],
          ),
        ),
        'copyFile': _i1.MethodConnector(
          name: 'copyFile',
          params: {
            'sourceServerPath': _i1.ParameterDescription(
              name: 'sourceServerPath',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'destinationServerPath': _i1.ParameterDescription(
              name: 'destinationServerPath',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['files'] as _i2.FilesEndpoint).copyFile(
            session,
            params['sourceServerPath'],
            params['destinationServerPath'],
          ),
        ),
        'renameFile': _i1.MethodConnector(
          name: 'renameFile',
          params: {
            'serverFilePath': _i1.ParameterDescription(
              name: 'serverFilePath',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newName': _i1.ParameterDescription(
              name: 'newName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['files'] as _i2.FilesEndpoint).renameFile(
            session,
            params['serverFilePath'],
            params['newName'],
          ),
        ),
        'moveFile': _i1.MethodConnector(
          name: 'moveFile',
          params: {
            'sourceServerPath': _i1.ParameterDescription(
              name: 'sourceServerPath',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'destinationServerPath': _i1.ParameterDescription(
              name: 'destinationServerPath',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['files'] as _i2.FilesEndpoint).moveFile(
            session,
            params['sourceServerPath'],
            params['destinationServerPath'],
          ),
        ),
        'list': _i1.MethodStreamConnector(
          name: 'list',
          params: {
            'serverFolderPath': _i1.ParameterDescription(
              name: 'serverFolderPath',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'filterByType': _i1.ParameterDescription(
              name: 'filterByType',
              type: _i1.getType<_i5.FsEntryType?>(),
              nullable: true,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['files'] as _i2.FilesEndpoint).list(
            session,
            serverFolderPath: params['serverFolderPath'],
            filterByType: params['filterByType'],
          ),
        ),
      },
    );
    connectors['links'] = _i1.EndpointConnector(
      name: 'links',
      endpoint: endpoints['links']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'serverPath': _i1.ParameterDescription(
              name: 'serverPath',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deleteAfter': _i1.ParameterDescription(
              name: 'deleteAfter',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['links'] as _i3.LinksEndpoint).create(
            session,
            serverPath: params['serverPath'],
            deleteAfter: params['deleteAfter'],
          ),
        ),
        'list': _i1.MethodConnector(
          name: 'list',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['links'] as _i3.LinksEndpoint).list(
            session,
            userId: params['userId'],
          ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'linkId': _i1.ParameterDescription(
              name: 'linkId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'serverPath': _i1.ParameterDescription(
              name: 'serverPath',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deleteAfter': _i1.ParameterDescription(
              name: 'deleteAfter',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'linkPrefix': _i1.ParameterDescription(
              name: 'linkPrefix',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['links'] as _i3.LinksEndpoint).update(
            session,
            linkId: params['linkId'],
            serverPath: params['serverPath'],
            deleteAfter: params['deleteAfter'],
            linkPrefix: params['linkPrefix'],
          ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'linkId': _i1.ParameterDescription(
              name: 'linkId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['links'] as _i3.LinksEndpoint).delete(
            session,
            params['linkId'],
          ),
        ),
      },
    );
    connectors['user'] = _i1.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'deleteMyUserProfile': _i1.MethodConnector(
          name: 'deleteMyUserProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i4.UserEndpoint).deleteMyUserProfile(
            session,
            params['userId'],
          ),
        )
      },
    );
    modules['serverpod_auth'] = _i6.Endpoints()..initializeEndpoints(server);
  }
}
