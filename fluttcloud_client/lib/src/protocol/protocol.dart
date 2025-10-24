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
import 'shared_link.dart' as _i5;
import 'shared_link_with_url.dart' as _i6;
import 'package:fluttcloud_client/src/protocol/shared_link_with_url.dart'
    as _i7;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i8;
export 'fs_entry.dart';
export 'fs_entry_content_type.dart';
export 'fs_entry_type.dart';
export 'shared_link.dart';
export 'shared_link_with_url.dart';
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
    if (t == _i5.SharedLink) {
      return _i5.SharedLink.fromJson(data) as T;
    }
    if (t == _i6.SharedLinkWithUrl) {
      return _i6.SharedLinkWithUrl.fromJson(data) as T;
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
    if (t == _i1.getType<_i5.SharedLink?>()) {
      return (data != null ? _i5.SharedLink.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.SharedLinkWithUrl?>()) {
      return (data != null ? _i6.SharedLinkWithUrl.fromJson(data) : null) as T;
    }
    if (t == List<_i7.SharedLinkWithUrl>) {
      return (data as List)
          .map((e) => deserialize<_i7.SharedLinkWithUrl>(e))
          .toList() as T;
    }
    try {
      return _i8.Protocol().deserialize<T>(data, t);
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
    if (data is _i5.SharedLink) {
      return 'SharedLink';
    }
    if (data is _i6.SharedLinkWithUrl) {
      return 'SharedLinkWithUrl';
    }
    className = _i8.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'SharedLink') {
      return deserialize<_i5.SharedLink>(data['data']);
    }
    if (dataClassName == 'SharedLinkWithUrl') {
      return deserialize<_i6.SharedLinkWithUrl>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i8.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
