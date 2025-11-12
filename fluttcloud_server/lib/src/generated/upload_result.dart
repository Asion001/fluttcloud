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

abstract class UploadResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UploadResult._({
    required this.success,
    required this.filePath,
    required this.fileName,
  });

  factory UploadResult({
    required bool success,
    required String filePath,
    required String fileName,
  }) = _UploadResultImpl;

  factory UploadResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return UploadResult(
      success: jsonSerialization['success'] as bool,
      filePath: jsonSerialization['filePath'] as String,
      fileName: jsonSerialization['fileName'] as String,
    );
  }

  bool success;

  String filePath;

  String fileName;

  /// Returns a shallow copy of this [UploadResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UploadResult copyWith({
    bool? success,
    String? filePath,
    String? fileName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'filePath': filePath,
      'fileName': fileName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'success': success,
      'filePath': filePath,
      'fileName': fileName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UploadResultImpl extends UploadResult {
  _UploadResultImpl({
    required bool success,
    required String filePath,
    required String fileName,
  }) : super._(
          success: success,
          filePath: filePath,
          fileName: fileName,
        );

  /// Returns a shallow copy of this [UploadResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UploadResult copyWith({
    bool? success,
    String? filePath,
    String? fileName,
  }) {
    return UploadResult(
      success: success ?? this.success,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
    );
  }
}
