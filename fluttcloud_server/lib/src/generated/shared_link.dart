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

abstract class SharedLink
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SharedLink._({
    this.id,
    required this.createdBy,
    required this.serverPath,
    required this.linkPrefix,
    this.deleteAfter,
    bool? canUpload,
  }) : canUpload = canUpload ?? false;

  factory SharedLink({
    int? id,
    required int createdBy,
    required String serverPath,
    required String linkPrefix,
    DateTime? deleteAfter,
    bool? canUpload,
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
      canUpload: jsonSerialization['canUpload'] as bool,
    );
  }

  static final t = SharedLinkTable();

  static const db = SharedLinkRepository._();

  @override
  int? id;

  /// User id
  int createdBy;

  /// Path to file or folder to share
  String serverPath;

  /// Link prefix. Example: https://domain.com/share/{linkPrefix}
  String linkPrefix;

  /// If set - link will be delete after this date
  DateTime? deleteAfter;

  /// If true - allows uploading files to the shared folder
  bool canUpload;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SharedLink]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SharedLink copyWith({
    int? id,
    int? createdBy,
    String? serverPath,
    String? linkPrefix,
    DateTime? deleteAfter,
    bool? canUpload,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'createdBy': createdBy,
      'serverPath': serverPath,
      'linkPrefix': linkPrefix,
      if (deleteAfter != null) 'deleteAfter': deleteAfter?.toJson(),
      'canUpload': canUpload,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'createdBy': createdBy,
      'serverPath': serverPath,
      'linkPrefix': linkPrefix,
      if (deleteAfter != null) 'deleteAfter': deleteAfter?.toJson(),
      'canUpload': canUpload,
    };
  }

  static SharedLinkInclude include() {
    return SharedLinkInclude._();
  }

  static SharedLinkIncludeList includeList({
    _i1.WhereExpressionBuilder<SharedLinkTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SharedLinkTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SharedLinkTable>? orderByList,
    SharedLinkInclude? include,
  }) {
    return SharedLinkIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedLink.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SharedLink.t),
      include: include,
    );
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
    bool? canUpload,
  }) : super._(
          id: id,
          createdBy: createdBy,
          serverPath: serverPath,
          linkPrefix: linkPrefix,
          deleteAfter: deleteAfter,
          canUpload: canUpload,
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
    bool? canUpload,
  }) {
    return SharedLink(
      id: id is int? ? id : this.id,
      createdBy: createdBy ?? this.createdBy,
      serverPath: serverPath ?? this.serverPath,
      linkPrefix: linkPrefix ?? this.linkPrefix,
      deleteAfter: deleteAfter is DateTime? ? deleteAfter : this.deleteAfter,
      canUpload: canUpload ?? this.canUpload,
    );
  }
}

class SharedLinkTable extends _i1.Table<int?> {
  SharedLinkTable({super.tableRelation}) : super(tableName: 'shared_link') {
    createdBy = _i1.ColumnInt(
      'createdBy',
      this,
    );
    serverPath = _i1.ColumnString(
      'serverPath',
      this,
    );
    linkPrefix = _i1.ColumnString(
      'linkPrefix',
      this,
    );
    deleteAfter = _i1.ColumnDateTime(
      'deleteAfter',
      this,
    );
    canUpload = _i1.ColumnBool(
      'canUpload',
      this,
      hasDefault: true,
    );
  }

  /// User id
  late final _i1.ColumnInt createdBy;

  /// Path to file or folder to share
  late final _i1.ColumnString serverPath;

  /// Link prefix. Example: https://domain.com/share/{linkPrefix}
  late final _i1.ColumnString linkPrefix;

  /// If set - link will be delete after this date
  late final _i1.ColumnDateTime deleteAfter;

  /// If true - allows uploading files to the shared folder
  late final _i1.ColumnBool canUpload;

  @override
  List<_i1.Column> get columns => [
        id,
        createdBy,
        serverPath,
        linkPrefix,
        deleteAfter,
        canUpload,
      ];
}

class SharedLinkInclude extends _i1.IncludeObject {
  SharedLinkInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SharedLink.t;
}

class SharedLinkIncludeList extends _i1.IncludeList {
  SharedLinkIncludeList._({
    _i1.WhereExpressionBuilder<SharedLinkTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SharedLink.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SharedLink.t;
}

class SharedLinkRepository {
  const SharedLinkRepository._();

  /// Returns a list of [SharedLink]s matching the given query parameters.
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
  Future<List<SharedLink>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SharedLinkTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SharedLinkTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SharedLinkTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SharedLink>(
      where: where?.call(SharedLink.t),
      orderBy: orderBy?.call(SharedLink.t),
      orderByList: orderByList?.call(SharedLink.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SharedLink] matching the given query parameters.
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
  Future<SharedLink?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SharedLinkTable>? where,
    int? offset,
    _i1.OrderByBuilder<SharedLinkTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SharedLinkTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SharedLink>(
      where: where?.call(SharedLink.t),
      orderBy: orderBy?.call(SharedLink.t),
      orderByList: orderByList?.call(SharedLink.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SharedLink] by its [id] or null if no such row exists.
  Future<SharedLink?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SharedLink>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SharedLink]s in the list and returns the inserted rows.
  ///
  /// The returned [SharedLink]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SharedLink>> insert(
    _i1.Session session,
    List<SharedLink> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SharedLink>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SharedLink] and returns the inserted row.
  ///
  /// The returned [SharedLink] will have its `id` field set.
  Future<SharedLink> insertRow(
    _i1.Session session,
    SharedLink row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SharedLink>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SharedLink]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SharedLink>> update(
    _i1.Session session,
    List<SharedLink> rows, {
    _i1.ColumnSelections<SharedLinkTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SharedLink>(
      rows,
      columns: columns?.call(SharedLink.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SharedLink]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SharedLink> updateRow(
    _i1.Session session,
    SharedLink row, {
    _i1.ColumnSelections<SharedLinkTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SharedLink>(
      row,
      columns: columns?.call(SharedLink.t),
      transaction: transaction,
    );
  }

  /// Deletes all [SharedLink]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SharedLink>> delete(
    _i1.Session session,
    List<SharedLink> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SharedLink>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SharedLink].
  Future<SharedLink> deleteRow(
    _i1.Session session,
    SharedLink row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SharedLink>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SharedLink>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SharedLinkTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SharedLink>(
      where: where(SharedLink.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SharedLinkTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SharedLink>(
      where: where?.call(SharedLink.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
