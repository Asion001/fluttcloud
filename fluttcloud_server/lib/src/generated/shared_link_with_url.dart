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
import 'shared_link.dart' as _i2;

abstract class SharedLinkWithUrl
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SharedLinkWithUrl._({
    required this.link,
    required this.fullUrl,
  });

  factory SharedLinkWithUrl({
    required _i2.SharedLink link,
    required String fullUrl,
  }) = _SharedLinkWithUrlImpl;

  factory SharedLinkWithUrl.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedLinkWithUrl(
      link: _i2.SharedLink.fromJson(
          (jsonSerialization['link'] as Map<String, dynamic>)),
      fullUrl: jsonSerialization['fullUrl'] as String,
    );
  }

  /// The shared link
  _i2.SharedLink link;

  /// Full URL for accessing the shared resource
  String fullUrl;

  /// Returns a shallow copy of this [SharedLinkWithUrl]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SharedLinkWithUrl copyWith({
    _i2.SharedLink? link,
    String? fullUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'link': link.toJson(),
      'fullUrl': fullUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'link': link.toJsonForProtocol(),
      'fullUrl': fullUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SharedLinkWithUrlImpl extends SharedLinkWithUrl {
  _SharedLinkWithUrlImpl({
    required _i2.SharedLink link,
    required String fullUrl,
  }) : super._(
          link: link,
          fullUrl: fullUrl,
        );

  /// Returns a shallow copy of this [SharedLinkWithUrl]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SharedLinkWithUrl copyWith({
    _i2.SharedLink? link,
    String? fullUrl,
  }) {
    return SharedLinkWithUrl(
      link: link ?? this.link.copyWith(),
      fullUrl: fullUrl ?? this.fullUrl,
    );
  }
}
