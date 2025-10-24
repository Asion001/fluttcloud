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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'fs_entry.dart' as _i4;
import 'fs_entry_content_type.dart' as _i5;
import 'fs_entry_type.dart' as _i6;
import 'shared_link.dart' as _i7;
import 'shared_link_with_url.dart' as _i8;
import 'user_folder_access.dart' as _i9;
import 'user_info_with_folders.dart' as _i10;
import 'package:fluttcloud_server/src/generated/user_info_with_folders.dart'
    as _i11;
import 'package:fluttcloud_server/src/generated/shared_link_with_url.dart'
    as _i12;
export 'fs_entry.dart';
export 'fs_entry_content_type.dart';
export 'fs_entry_type.dart';
export 'shared_link.dart';
export 'shared_link_with_url.dart';
export 'user_folder_access.dart';
export 'user_info_with_folders.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'shared_link',
      dartName: 'SharedLink',
      schema: 'public',
      module: 'fluttcloud',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'shared_link_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'serverPath',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'linkPrefix',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'deleteAfter',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'shared_link_fk_0',
          columns: ['createdBy'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'shared_link_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'shared_link_created_by_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdBy',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'shared_link_prefix_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'linkPrefix',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_folder_access',
      dartName: 'UserFolderAccess',
      schema: 'public',
      module: 'fluttcloud',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'user_folder_access_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'folderPath',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_folder_access_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_folder_access_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'folderPath',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i4.FsEntry) {
      return _i4.FsEntry.fromJson(data) as T;
    }
    if (t == _i5.FsEntryContentType) {
      return _i5.FsEntryContentType.fromJson(data) as T;
    }
    if (t == _i6.FsEntryType) {
      return _i6.FsEntryType.fromJson(data) as T;
    }
    if (t == _i7.SharedLink) {
      return _i7.SharedLink.fromJson(data) as T;
    }
    if (t == _i8.SharedLinkWithUrl) {
      return _i8.SharedLinkWithUrl.fromJson(data) as T;
    }
    if (t == _i9.UserFolderAccess) {
      return _i9.UserFolderAccess.fromJson(data) as T;
    }
    if (t == _i10.UserInfoWithFolders) {
      return _i10.UserInfoWithFolders.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.FsEntry?>()) {
      return (data != null ? _i4.FsEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.FsEntryContentType?>()) {
      return (data != null ? _i5.FsEntryContentType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.FsEntryType?>()) {
      return (data != null ? _i6.FsEntryType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.SharedLink?>()) {
      return (data != null ? _i7.SharedLink.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.SharedLinkWithUrl?>()) {
      return (data != null ? _i8.SharedLinkWithUrl.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.UserFolderAccess?>()) {
      return (data != null ? _i9.UserFolderAccess.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.UserInfoWithFolders?>()) {
      return (data != null ? _i10.UserInfoWithFolders.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i11.UserInfoWithFolders>) {
      return (data as List)
          .map((e) => deserialize<_i11.UserInfoWithFolders>(e))
          .toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as T;
    }
    if (t == List<_i12.SharedLinkWithUrl>) {
      return (data as List)
          .map((e) => deserialize<_i12.SharedLinkWithUrl>(e))
          .toList() as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i4.FsEntry) {
      return 'FsEntry';
    }
    if (data is _i5.FsEntryContentType) {
      return 'FsEntryContentType';
    }
    if (data is _i6.FsEntryType) {
      return 'FsEntryType';
    }
    if (data is _i7.SharedLink) {
      return 'SharedLink';
    }
    if (data is _i8.SharedLinkWithUrl) {
      return 'SharedLinkWithUrl';
    }
    if (data is _i9.UserFolderAccess) {
      return 'UserFolderAccess';
    }
    if (data is _i10.UserInfoWithFolders) {
      return 'UserInfoWithFolders';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'FsEntry') {
      return deserialize<_i4.FsEntry>(data['data']);
    }
    if (dataClassName == 'FsEntryContentType') {
      return deserialize<_i5.FsEntryContentType>(data['data']);
    }
    if (dataClassName == 'FsEntryType') {
      return deserialize<_i6.FsEntryType>(data['data']);
    }
    if (dataClassName == 'SharedLink') {
      return deserialize<_i7.SharedLink>(data['data']);
    }
    if (dataClassName == 'SharedLinkWithUrl') {
      return deserialize<_i8.SharedLinkWithUrl>(data['data']);
    }
    if (dataClassName == 'UserFolderAccess') {
      return deserialize<_i9.UserFolderAccess>(data['data']);
    }
    if (dataClassName == 'UserInfoWithFolders') {
      return deserialize<_i10.UserInfoWithFolders>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i7.SharedLink:
        return _i7.SharedLink.t;
      case _i9.UserFolderAccess:
        return _i9.UserFolderAccess.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'fluttcloud';
}
