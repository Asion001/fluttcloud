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
import 'user_info_with_folders.dart' as _i2;

abstract class PaginatedUsersResult implements _i1.SerializableModel {
  PaginatedUsersResult._({
    required this.users,
    required this.totalCount,
    required this.pageSize,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedUsersResult({
    required List<_i2.UserInfoWithFolders> users,
    required int totalCount,
    required int pageSize,
    required int currentPage,
    required int totalPages,
    required bool hasNextPage,
    required bool hasPreviousPage,
  }) = _PaginatedUsersResultImpl;

  factory PaginatedUsersResult.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PaginatedUsersResult(
      users: (jsonSerialization['users'] as List)
          .map((e) =>
              _i2.UserInfoWithFolders.fromJson((e as Map<String, dynamic>)))
          .toList(),
      totalCount: jsonSerialization['totalCount'] as int,
      pageSize: jsonSerialization['pageSize'] as int,
      currentPage: jsonSerialization['currentPage'] as int,
      totalPages: jsonSerialization['totalPages'] as int,
      hasNextPage: jsonSerialization['hasNextPage'] as bool,
      hasPreviousPage: jsonSerialization['hasPreviousPage'] as bool,
    );
  }

  List<_i2.UserInfoWithFolders> users;

  int totalCount;

  int pageSize;

  int currentPage;

  int totalPages;

  bool hasNextPage;

  bool hasPreviousPage;

  /// Returns a shallow copy of this [PaginatedUsersResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaginatedUsersResult copyWith({
    List<_i2.UserInfoWithFolders>? users,
    int? totalCount,
    int? pageSize,
    int? currentPage,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'users': users.toJson(valueToJson: (v) => v.toJson()),
      'totalCount': totalCount,
      'pageSize': pageSize,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PaginatedUsersResultImpl extends PaginatedUsersResult {
  _PaginatedUsersResultImpl({
    required List<_i2.UserInfoWithFolders> users,
    required int totalCount,
    required int pageSize,
    required int currentPage,
    required int totalPages,
    required bool hasNextPage,
    required bool hasPreviousPage,
  }) : super._(
          users: users,
          totalCount: totalCount,
          pageSize: pageSize,
          currentPage: currentPage,
          totalPages: totalPages,
          hasNextPage: hasNextPage,
          hasPreviousPage: hasPreviousPage,
        );

  /// Returns a shallow copy of this [PaginatedUsersResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaginatedUsersResult copyWith({
    List<_i2.UserInfoWithFolders>? users,
    int? totalCount,
    int? pageSize,
    int? currentPage,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PaginatedUsersResult(
      users: users ?? this.users.map((e0) => e0.copyWith()).toList(),
      totalCount: totalCount ?? this.totalCount,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }
}
