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
import 'fs_entry_type.dart' as _i2;
import 'fs_entry_content_type.dart' as _i3;

abstract class FsEntry
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FsEntry._({
    required this.fullpath,
    required this.serverFullpath,
    required this.createdAt,
    required this.updatedAt,
    this.size,
    required this.type,
    required this.privateShareUrl,
    required this.contentType,
  });

  factory FsEntry({
    required String fullpath,
    required String serverFullpath,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? size,
    required _i2.FsEntryType type,
    required String privateShareUrl,
    required _i3.FsEntryContentType contentType,
  }) = _FsEntryImpl;

  factory FsEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return FsEntry(
      fullpath: jsonSerialization['fullpath'] as String,
      serverFullpath: jsonSerialization['serverFullpath'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      size: jsonSerialization['size'] as int?,
      type: _i2.FsEntryType.fromJson((jsonSerialization['type'] as int)),
      privateShareUrl: jsonSerialization['privateShareUrl'] as String,
      contentType: _i3.FsEntryContentType.fromJson(
          (jsonSerialization['contentType'] as int)),
    );
  }

  String fullpath;

  String serverFullpath;

  DateTime createdAt;

  DateTime updatedAt;

  int? size;

  _i2.FsEntryType type;

  String privateShareUrl;

  _i3.FsEntryContentType contentType;

  /// Returns a shallow copy of this [FsEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FsEntry copyWith({
    String? fullpath,
    String? serverFullpath,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? size,
    _i2.FsEntryType? type,
    String? privateShareUrl,
    _i3.FsEntryContentType? contentType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'fullpath': fullpath,
      'serverFullpath': serverFullpath,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (size != null) 'size': size,
      'type': type.toJson(),
      'privateShareUrl': privateShareUrl,
      'contentType': contentType.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'fullpath': fullpath,
      'serverFullpath': serverFullpath,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (size != null) 'size': size,
      'type': type.toJson(),
      'privateShareUrl': privateShareUrl,
      'contentType': contentType.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FsEntryImpl extends FsEntry {
  _FsEntryImpl({
    required String fullpath,
    required String serverFullpath,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? size,
    required _i2.FsEntryType type,
    required String privateShareUrl,
    required _i3.FsEntryContentType contentType,
  }) : super._(
          fullpath: fullpath,
          serverFullpath: serverFullpath,
          createdAt: createdAt,
          updatedAt: updatedAt,
          size: size,
          type: type,
          privateShareUrl: privateShareUrl,
          contentType: contentType,
        );

  /// Returns a shallow copy of this [FsEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FsEntry copyWith({
    String? fullpath,
    String? serverFullpath,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? size = _Undefined,
    _i2.FsEntryType? type,
    String? privateShareUrl,
    _i3.FsEntryContentType? contentType,
  }) {
    return FsEntry(
      fullpath: fullpath ?? this.fullpath,
      serverFullpath: serverFullpath ?? this.serverFullpath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      size: size is int? ? size : this.size,
      type: type ?? this.type,
      privateShareUrl: privateShareUrl ?? this.privateShareUrl,
      contentType: contentType ?? this.contentType,
    );
  }
}
