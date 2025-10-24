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

abstract class UserFolderAccess
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = UserFolderAccessTable();

  static const db = UserFolderAccessRepository._();

  @override
  int? id;

  int userId;

  String folderPath;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'folderPath': folderPath,
    };
  }

  static UserFolderAccessInclude include() {
    return UserFolderAccessInclude._();
  }

  static UserFolderAccessIncludeList includeList({
    _i1.WhereExpressionBuilder<UserFolderAccessTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserFolderAccessTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserFolderAccessTable>? orderByList,
    UserFolderAccessInclude? include,
  }) {
    return UserFolderAccessIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserFolderAccess.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserFolderAccess.t),
      include: include,
    );
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

class UserFolderAccessTable extends _i1.Table<int?> {
  UserFolderAccessTable({super.tableRelation})
      : super(tableName: 'user_folder_access') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    folderPath = _i1.ColumnString(
      'folderPath',
      this,
    );
  }

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString folderPath;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        folderPath,
      ];
}

class UserFolderAccessInclude extends _i1.IncludeObject {
  UserFolderAccessInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserFolderAccess.t;
}

class UserFolderAccessIncludeList extends _i1.IncludeList {
  UserFolderAccessIncludeList._({
    _i1.WhereExpressionBuilder<UserFolderAccessTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserFolderAccess.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserFolderAccess.t;
}

class UserFolderAccessRepository {
  const UserFolderAccessRepository._();

  /// Returns a list of [UserFolderAccess]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<UserFolderAccess>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserFolderAccessTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserFolderAccessTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserFolderAccessTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserFolderAccess>(
      where: where?.call(UserFolderAccess.t),
      orderBy: orderBy?.call(UserFolderAccess.t),
      orderByList: orderByList?.call(UserFolderAccess.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserFolderAccess] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<UserFolderAccess?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserFolderAccessTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserFolderAccessTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserFolderAccessTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserFolderAccess>(
      where: where?.call(UserFolderAccess.t),
      orderBy: orderBy?.call(UserFolderAccess.t),
      orderByList: orderByList?.call(UserFolderAccess.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserFolderAccess] by its [id] or null if no such row exists.
  Future<UserFolderAccess?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserFolderAccess>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserFolderAccess]s in the list and returns the inserted rows.
  ///
  /// The returned [UserFolderAccess]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserFolderAccess>> insert(
    _i1.Session session,
    List<UserFolderAccess> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserFolderAccess>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserFolderAccess] and returns the inserted row.
  ///
  /// The returned [UserFolderAccess] will have its `id` field set.
  Future<UserFolderAccess> insertRow(
    _i1.Session session,
    UserFolderAccess row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserFolderAccess>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserFolderAccess]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserFolderAccess>> update(
    _i1.Session session,
    List<UserFolderAccess> rows, {
    _i1.ColumnSelections<UserFolderAccessTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserFolderAccess>(
      rows,
      columns: columns?.call(UserFolderAccess.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserFolderAccess]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserFolderAccess> updateRow(
    _i1.Session session,
    UserFolderAccess row, {
    _i1.ColumnSelections<UserFolderAccessTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserFolderAccess>(
      row,
      columns: columns?.call(UserFolderAccess.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserFolderAccess]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserFolderAccess>> delete(
    _i1.Session session,
    List<UserFolderAccess> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserFolderAccess>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserFolderAccess].
  Future<UserFolderAccess> deleteRow(
    _i1.Session session,
    UserFolderAccess row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserFolderAccess>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserFolderAccess>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserFolderAccessTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserFolderAccess>(
      where: where(UserFolderAccess.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserFolderAccessTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserFolderAccess>(
      where: where?.call(UserFolderAccess.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
