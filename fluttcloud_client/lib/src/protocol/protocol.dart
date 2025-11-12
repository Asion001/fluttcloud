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
import 'fs_entry.dart' as _i2;
import 'fs_entry_content_type.dart' as _i3;
import 'fs_entry_type.dart' as _i4;
import 'paginated_users_result.dart' as _i5;
import 'shared_link.dart' as _i6;
import 'shared_link_with_url.dart' as _i7;
import 'upload_result.dart' as _i8;
import 'user_folder_access.dart' as _i9;
import 'user_info_with_folders.dart' as _i10;
import 'package:fluttcloud_client/src/protocol/shared_link_with_url.dart'
    as _i11;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i12;
export 'fs_entry.dart';
export 'fs_entry_content_type.dart';
export 'fs_entry_type.dart';
export 'paginated_users_result.dart';
export 'shared_link.dart';
export 'shared_link_with_url.dart';
export 'upload_result.dart';
export 'user_folder_access.dart';
export 'user_info_with_folders.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.FsEntry) {
      return _i2.FsEntry.fromJson(data) as T;
    }
    if (t == _i3.FsEntryContentType) {
      return _i3.FsEntryContentType.fromJson(data) as T;
    }
    if (t == _i4.FsEntryType) {
      return _i4.FsEntryType.fromJson(data) as T;
    }
    if (t == _i5.PaginatedUsersResult) {
      return _i5.PaginatedUsersResult.fromJson(data) as T;
    }
    if (t == _i6.SharedLink) {
      return _i6.SharedLink.fromJson(data) as T;
    }
    if (t == _i7.SharedLinkWithUrl) {
      return _i7.SharedLinkWithUrl.fromJson(data) as T;
    }
    if (t == _i8.UploadResult) {
      return _i8.UploadResult.fromJson(data) as T;
    }
    if (t == _i9.UserFolderAccess) {
      return _i9.UserFolderAccess.fromJson(data) as T;
    }
    if (t == _i10.UserInfoWithFolders) {
      return _i10.UserInfoWithFolders.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.FsEntry?>()) {
      return (data != null ? _i2.FsEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.FsEntryContentType?>()) {
      return (data != null ? _i3.FsEntryContentType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.FsEntryType?>()) {
      return (data != null ? _i4.FsEntryType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.PaginatedUsersResult?>()) {
      return (data != null ? _i5.PaginatedUsersResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.SharedLink?>()) {
      return (data != null ? _i6.SharedLink.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.SharedLinkWithUrl?>()) {
      return (data != null ? _i7.SharedLinkWithUrl.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.UploadResult?>()) {
      return (data != null ? _i8.UploadResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.UserFolderAccess?>()) {
      return (data != null ? _i9.UserFolderAccess.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.UserInfoWithFolders?>()) {
      return (data != null ? _i10.UserInfoWithFolders.fromJson(data) : null)
          as T;
    }
    if (t == List<_i10.UserInfoWithFolders>) {
      return (data as List)
          .map((e) => deserialize<_i10.UserInfoWithFolders>(e))
          .toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as T;
    }
    if (t == List<_i11.SharedLinkWithUrl>) {
      return (data as List)
          .map((e) => deserialize<_i11.SharedLinkWithUrl>(e))
          .toList() as T;
    }
    try {
      return _i12.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.FsEntry) {
      return 'FsEntry';
    }
    if (data is _i3.FsEntryContentType) {
      return 'FsEntryContentType';
    }
    if (data is _i4.FsEntryType) {
      return 'FsEntryType';
    }
    if (data is _i5.PaginatedUsersResult) {
      return 'PaginatedUsersResult';
    }
    if (data is _i6.SharedLink) {
      return 'SharedLink';
    }
    if (data is _i7.SharedLinkWithUrl) {
      return 'SharedLinkWithUrl';
    }
    if (data is _i8.UploadResult) {
      return 'UploadResult';
    }
    if (data is _i9.UserFolderAccess) {
      return 'UserFolderAccess';
    }
    if (data is _i10.UserInfoWithFolders) {
      return 'UserInfoWithFolders';
    }
    className = _i12.Protocol().getClassNameForObject(data);
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
      return deserialize<_i2.FsEntry>(data['data']);
    }
    if (dataClassName == 'FsEntryContentType') {
      return deserialize<_i3.FsEntryContentType>(data['data']);
    }
    if (dataClassName == 'FsEntryType') {
      return deserialize<_i4.FsEntryType>(data['data']);
    }
    if (dataClassName == 'PaginatedUsersResult') {
      return deserialize<_i5.PaginatedUsersResult>(data['data']);
    }
    if (dataClassName == 'SharedLink') {
      return deserialize<_i6.SharedLink>(data['data']);
    }
    if (dataClassName == 'SharedLinkWithUrl') {
      return deserialize<_i7.SharedLinkWithUrl>(data['data']);
    }
    if (dataClassName == 'UploadResult') {
      return deserialize<_i8.UploadResult>(data['data']);
    }
    if (dataClassName == 'UserFolderAccess') {
      return deserialize<_i9.UserFolderAccess>(data['data']);
    }
    if (dataClassName == 'UserInfoWithFolders') {
      return deserialize<_i10.UserInfoWithFolders>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i12.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
