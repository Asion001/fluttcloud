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
export 'fs_entry.dart';
export 'fs_entry_content_type.dart';
export 'fs_entry_type.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
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
    if (t == _i1.getType<_i4.FsEntry?>()) {
      return (data != null ? _i4.FsEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.FsEntryContentType?>()) {
      return (data != null ? _i5.FsEntryContentType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.FsEntryType?>()) {
      return (data != null ? _i6.FsEntryType.fromJson(data) : null) as T;
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
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'fluttcloud';
}
