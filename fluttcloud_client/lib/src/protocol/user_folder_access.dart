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

abstract class UserFolderAccess implements _i1.SerializableModel {
  UserFolderAccess._({
    this.id,
    required this.userId,
    required this.folderPath,
  });

  factory UserFolderAccess({
    int? id,
    required int userId,
    required String folderPath,
  }) = _UserFolderAccessImpl;

  factory UserFolderAccess.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserFolderAccess(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      folderPath: jsonSerialization['folderPath'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String folderPath;

  /// Returns a shallow copy of this [UserFolderAccess]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserFolderAccess copyWith({
    int? id,
    int? userId,
    String? folderPath,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'folderPath': folderPath,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserFolderAccessImpl extends UserFolderAccess {
  _UserFolderAccessImpl({
    int? id,
    required int userId,
    required String folderPath,
  }) : super._(
          id: id,
          userId: userId,
          folderPath: folderPath,
        );

  /// Returns a shallow copy of this [UserFolderAccess]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserFolderAccess copyWith({
    Object? id = _Undefined,
    int? userId,
    String? folderPath,
  }) {
    return UserFolderAccess(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      folderPath: folderPath ?? this.folderPath,
    );
  }
}
