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
import 'fs_entry.dart' as _i3;
import 'fs_entry_content_type.dart' as _i4;
import 'fs_entry_type.dart' as _i5;
import 'paginated_users_result.dart' as _i6;
import 'shared_link_with_url.dart' as _i7;
import 'upload_result.dart' as _i8;
import 'user_info_with_folders.dart' as _i9;
export 'fs_entry.dart';
export 'fs_entry_content_type.dart';
export 'fs_entry_type.dart';
export 'paginated_users_result.dart';
export 'shared_link_with_url.dart';
export 'upload_result.dart';
export 'user_info_with_folders.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    ..._i2.Protocol.targetTableDefinitions
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i3.FsEntry) {
      return _i3.FsEntry.fromJson(data) as T;
    }
    if (t == _i4.FsEntryContentType) {
      return _i4.FsEntryContentType.fromJson(data) as T;
    }
    if (t == _i5.FsEntryType) {
      return _i5.FsEntryType.fromJson(data) as T;
    }
    if (t == _i6.PaginatedUsersResult) {
      return _i6.PaginatedUsersResult.fromJson(data) as T;
    }
    if (t == _i7.SharedLinkWithUrl) {
      return _i7.SharedLinkWithUrl.fromJson(data) as T;
    }
    if (t == _i8.UploadResult) {
      return _i8.UploadResult.fromJson(data) as T;
    }
    if (t == _i9.UserInfoWithFolders) {
      return _i9.UserInfoWithFolders.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.FsEntry?>()) {
      return (data != null ? _i3.FsEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.FsEntryContentType?>()) {
      return (data != null ? _i4.FsEntryContentType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.FsEntryType?>()) {
      return (data != null ? _i5.FsEntryType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.PaginatedUsersResult?>()) {
      return (data != null ? _i6.PaginatedUsersResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.SharedLinkWithUrl?>()) {
      return (data != null ? _i7.SharedLinkWithUrl.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.UploadResult?>()) {
      return (data != null ? _i8.UploadResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.UserInfoWithFolders?>()) {
      return (data != null ? _i9.UserInfoWithFolders.fromJson(data) : null)
          as T;
    }
    if (t == List<_i9.UserInfoWithFolders>) {
      return (data as List)
          .map((e) => deserialize<_i9.UserInfoWithFolders>(e))
          .toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i3.FsEntry) {
      return 'FsEntry';
    }
    if (data is _i4.FsEntryContentType) {
      return 'FsEntryContentType';
    }
    if (data is _i5.FsEntryType) {
      return 'FsEntryType';
    }
    if (data is _i6.PaginatedUsersResult) {
      return 'PaginatedUsersResult';
    }
    if (data is _i7.SharedLinkWithUrl) {
      return 'SharedLinkWithUrl';
    }
    if (data is _i8.UploadResult) {
      return 'UploadResult';
    }
    if (data is _i9.UserInfoWithFolders) {
      return 'UserInfoWithFolders';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
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
      return deserialize<_i3.FsEntry>(data['data']);
    }
    if (dataClassName == 'FsEntryContentType') {
      return deserialize<_i4.FsEntryContentType>(data['data']);
    }
    if (dataClassName == 'FsEntryType') {
      return deserialize<_i5.FsEntryType>(data['data']);
    }
    if (dataClassName == 'PaginatedUsersResult') {
      return deserialize<_i6.PaginatedUsersResult>(data['data']);
    }
    if (dataClassName == 'SharedLinkWithUrl') {
      return deserialize<_i7.SharedLinkWithUrl>(data['data']);
    }
    if (dataClassName == 'UploadResult') {
      return deserialize<_i8.UploadResult>(data['data']);
    }
    if (dataClassName == 'UserInfoWithFolders') {
      return deserialize<_i9.UserInfoWithFolders>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'fluttcloud';
}
