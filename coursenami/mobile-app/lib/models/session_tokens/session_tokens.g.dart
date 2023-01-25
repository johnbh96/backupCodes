// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

part of 'session_tokens.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AccessToken> _$accessTokenSerializer = new _$AccessTokenSerializer();
Serializer<RefreshToken> _$refreshTokenSerializer =
    new _$RefreshTokenSerializer();

class _$AccessTokenSerializer implements StructuredSerializer<AccessToken> {
  @override
  final Iterable<Type> types = const [AccessToken, _$AccessToken];
  @override
  final String wireName = 'AccessToken';

  @override
  Iterable<Object?> serialize(Serializers serializers, AccessToken object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'access',
      serializers.serialize(object.access,
          specifiedType: const FullType(String)),
      'access_token_expiration',
      serializers.serialize(object.accessTokenExpiration,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  AccessToken deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AccessTokenBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'access':
          result.access = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'access_token_expiration':
          result.accessTokenExpiration = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$RefreshTokenSerializer implements StructuredSerializer<RefreshToken> {
  @override
  final Iterable<Type> types = const [RefreshToken, _$RefreshToken];
  @override
  final String wireName = 'RefreshToken';

  @override
  Iterable<Object?> serialize(Serializers serializers, RefreshToken object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.refreshToken;
    if (value != null) {
      result
        ..add('refresh')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  RefreshToken deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RefreshTokenBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'refresh':
          result.refreshToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$AccessToken extends AccessToken {
  @override
  final String access;
  @override
  final String accessTokenExpiration;

  factory _$AccessToken([void Function(AccessTokenBuilder)? updates]) =>
      (new AccessTokenBuilder()..update(updates))._build();

  _$AccessToken._({required this.access, required this.accessTokenExpiration})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(access, r'AccessToken', 'access');
    BuiltValueNullFieldError.checkNotNull(
        accessTokenExpiration, r'AccessToken', 'accessTokenExpiration');
  }

  @override
  AccessToken rebuild(void Function(AccessTokenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccessTokenBuilder toBuilder() => new AccessTokenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccessToken &&
        access == other.access &&
        accessTokenExpiration == other.accessTokenExpiration;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, access.hashCode), accessTokenExpiration.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccessToken')
          ..add('access', access)
          ..add('accessTokenExpiration', accessTokenExpiration))
        .toString();
  }
}

class AccessTokenBuilder implements Builder<AccessToken, AccessTokenBuilder> {
  _$AccessToken? _$v;

  String? _access;
  String? get access => _$this._access;
  set access(String? access) => _$this._access = access;

  String? _accessTokenExpiration;
  String? get accessTokenExpiration => _$this._accessTokenExpiration;
  set accessTokenExpiration(String? accessTokenExpiration) =>
      _$this._accessTokenExpiration = accessTokenExpiration;

  AccessTokenBuilder();

  AccessTokenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _access = $v.access;
      _accessTokenExpiration = $v.accessTokenExpiration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccessToken other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AccessToken;
  }

  @override
  void update(void Function(AccessTokenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccessToken build() => _build();

  _$AccessToken _build() {
    final _$result = _$v ??
        new _$AccessToken._(
            access: BuiltValueNullFieldError.checkNotNull(
                access, r'AccessToken', 'access'),
            accessTokenExpiration: BuiltValueNullFieldError.checkNotNull(
                accessTokenExpiration,
                r'AccessToken',
                'accessTokenExpiration'));
    replace(_$result);
    return _$result;
  }
}

class _$RefreshToken extends RefreshToken {
  @override
  final String? refreshToken;

  factory _$RefreshToken([void Function(RefreshTokenBuilder)? updates]) =>
      (new RefreshTokenBuilder()..update(updates))._build();

  _$RefreshToken._({this.refreshToken}) : super._();

  @override
  RefreshToken rebuild(void Function(RefreshTokenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RefreshTokenBuilder toBuilder() => new RefreshTokenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RefreshToken && refreshToken == other.refreshToken;
  }

  @override
  int get hashCode {
    return $jf($jc(0, refreshToken.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RefreshToken')
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class RefreshTokenBuilder
    implements Builder<RefreshToken, RefreshTokenBuilder> {
  _$RefreshToken? _$v;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  RefreshTokenBuilder();

  RefreshTokenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RefreshToken other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RefreshToken;
  }

  @override
  void update(void Function(RefreshTokenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RefreshToken build() => _build();

  _$RefreshToken _build() {
    final _$result = _$v ?? new _$RefreshToken._(refreshToken: refreshToken);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
