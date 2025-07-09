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

abstract class SharedLink implements _i1.SerializableModel {
  SharedLink._({
    this.id,
    required this.createdBy,
    required this.serverPath,
    required this.linkPrefix,
    this.deleteAfter,
  });

  factory SharedLink({
    int? id,
    required int createdBy,
    required String serverPath,
    required String linkPrefix,
    DateTime? deleteAfter,
  }) = _SharedLinkImpl;

  factory SharedLink.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedLink(
      id: jsonSerialization['id'] as int?,
      createdBy: jsonSerialization['createdBy'] as int,
      serverPath: jsonSerialization['serverPath'] as String,
      linkPrefix: jsonSerialization['linkPrefix'] as String,
      deleteAfter: jsonSerialization['deleteAfter'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deleteAfter']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// User id
  int createdBy;

  /// Path to file or folder to share
  String serverPath;

  /// Link prefix. Example: https://domain.com/share/{linkPrefix}
  String linkPrefix;

  /// If set - link will be delete after this date
  DateTime? deleteAfter;

  /// Returns a shallow copy of this [SharedLink]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SharedLink copyWith({
    int? id,
    int? createdBy,
    String? serverPath,
    String? linkPrefix,
    DateTime? deleteAfter,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'createdBy': createdBy,
      'serverPath': serverPath,
      'linkPrefix': linkPrefix,
      if (deleteAfter != null) 'deleteAfter': deleteAfter?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedLinkImpl extends SharedLink {
  _SharedLinkImpl({
    int? id,
    required int createdBy,
    required String serverPath,
    required String linkPrefix,
    DateTime? deleteAfter,
  }) : super._(
          id: id,
          createdBy: createdBy,
          serverPath: serverPath,
          linkPrefix: linkPrefix,
          deleteAfter: deleteAfter,
        );

  /// Returns a shallow copy of this [SharedLink]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SharedLink copyWith({
    Object? id = _Undefined,
    int? createdBy,
    String? serverPath,
    String? linkPrefix,
    Object? deleteAfter = _Undefined,
  }) {
    return SharedLink(
      id: id is int? ? id : this.id,
      createdBy: createdBy ?? this.createdBy,
      serverPath: serverPath ?? this.serverPath,
      linkPrefix: linkPrefix ?? this.linkPrefix,
      deleteAfter: deleteAfter is DateTime? ? deleteAfter : this.deleteAfter,
    );
  }
}
