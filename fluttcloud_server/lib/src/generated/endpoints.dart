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
import '../endpoinds/user_endpoint.dart' as _i3;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i4;

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
      'user': _i3.UserEndpoint()
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
        'list': _i1.MethodStreamConnector(
          name: 'list',
          params: {
            'serverFolderPath': _i1.ParameterDescription(
              name: 'serverFolderPath',
              type: _i1.getType<String?>(),
              nullable: true,
            )
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
              (endpoints['user'] as _i3.UserEndpoint).deleteMyUserProfile(
            session,
            params['userId'],
          ),
        )
      },
    );
    modules['serverpod_auth'] = _i4.Endpoints()..initializeEndpoints(server);
  }
}
