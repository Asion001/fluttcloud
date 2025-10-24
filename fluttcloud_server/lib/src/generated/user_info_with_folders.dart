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

abstract class UserInfoWithFolders
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UserInfoWithFolders._({
    required this.userId,
    this.userName,
    required this.email,
    this.fullName,
    required this.isAdmin,
    required this.folderPaths,
  });

  factory UserInfoWithFolders({
    required int userId,
    String? userName,
    required String email,
    String? fullName,
    required bool isAdmin,
    required List<String> folderPaths,
  }) = _UserInfoWithFoldersImpl;

  factory UserInfoWithFolders.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserInfoWithFolders(
      userId: jsonSerialization['userId'] as int,
      userName: jsonSerialization['userName'] as String?,
      email: jsonSerialization['email'] as String,
      fullName: jsonSerialization['fullName'] as String?,
      isAdmin: jsonSerialization['isAdmin'] as bool,
      folderPaths: (jsonSerialization['folderPaths'] as List)
          .map((e) => e as String)
          .toList(),
    );
  }

  int userId;

  String? userName;

  String email;

  String? fullName;

  bool isAdmin;

  List<String> folderPaths;

  /// Returns a shallow copy of this [UserInfoWithFolders]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserInfoWithFolders copyWith({
    int? userId,
    String? userName,
    String? email,
    String? fullName,
    bool? isAdmin,
    List<String>? folderPaths,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      if (userName != null) 'userName': userName,
      'email': email,
      if (fullName != null) 'fullName': fullName,
      'isAdmin': isAdmin,
      'folderPaths': folderPaths.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'userId': userId,
      if (userName != null) 'userName': userName,
      'email': email,
      if (fullName != null) 'fullName': fullName,
      'isAdmin': isAdmin,
      'folderPaths': folderPaths.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserInfoWithFoldersImpl extends UserInfoWithFolders {
  _UserInfoWithFoldersImpl({
    required int userId,
    String? userName,
    required String email,
    String? fullName,
    required bool isAdmin,
    required List<String> folderPaths,
  }) : super._(
          userId: userId,
          userName: userName,
          email: email,
          fullName: fullName,
          isAdmin: isAdmin,
          folderPaths: folderPaths,
        );

  /// Returns a shallow copy of this [UserInfoWithFolders]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserInfoWithFolders copyWith({
    int? userId,
    Object? userName = _Undefined,
    String? email,
    Object? fullName = _Undefined,
    bool? isAdmin,
    List<String>? folderPaths,
  }) {
    return UserInfoWithFolders(
      userId: userId ?? this.userId,
      userName: userName is String? ? userName : this.userName,
      email: email ?? this.email,
      fullName: fullName is String? ? fullName : this.fullName,
      isAdmin: isAdmin ?? this.isAdmin,
      folderPaths: folderPaths ?? this.folderPaths.map((e0) => e0).toList(),
    );
  }
}
