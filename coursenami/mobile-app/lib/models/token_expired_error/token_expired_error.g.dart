// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

part of 'token_expired_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TokenExpiredError> _$tokenExpiredErrorSerializer =
    new _$TokenExpiredErrorSerializer();
Serializer<TokenExpiredErrorMessage> _$tokenExpiredErrorMessageSerializer =
    new _$TokenExpiredErrorMessageSerializer();

class _$TokenExpiredErrorSerializer
    implements StructuredSerializer<TokenExpiredError> {
  @override
  final Iterable<Type> types = const [TokenExpiredError, _$TokenExpiredError];
  @override
  final String wireName = 'TokenExpiredError';

  @override
  Iterable<Object?> serialize(Serializers serializers, TokenExpiredError object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(
              BuiltList, const [const FullType(TokenExpiredErrorMessage)])),
    ];
    Object? value;
    value = object.code;
    if (value != null) {
      result
        ..add('code')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  TokenExpiredError deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TokenExpiredErrorBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'code':
          result.code = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'message':
          result.message.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(TokenExpiredErrorMessage)
              ]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$TokenExpiredErrorMessageSerializer
    implements StructuredSerializer<TokenExpiredErrorMessage> {
  @override
  final Iterable<Type> types = const [
    TokenExpiredErrorMessage,
    _$TokenExpiredErrorMessage
  ];
  @override
  final String wireName = 'TokenExpiredErrorMessage';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, TokenExpiredErrorMessage object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.tokenClass;
    if (value != null) {
      result
        ..add('token_class')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.tokenType;
    if (value != null) {
      result
        ..add('token_type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.message;
    if (value != null) {
      result
        ..add('message')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  TokenExpiredErrorMessage deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TokenExpiredErrorMessageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'token_class':
          result.tokenClass = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'token_type':
          result.tokenType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$TokenExpiredError extends TokenExpiredError {
  @override
  final String? code;
  @override
  final BuiltList<TokenExpiredErrorMessage> message;

  factory _$TokenExpiredError(
          [void Function(TokenExpiredErrorBuilder)? updates]) =>
      (new TokenExpiredErrorBuilder()..update(updates))._build();

  _$TokenExpiredError._({this.code, required this.message}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        message, r'TokenExpiredError', 'message');
  }

  @override
  TokenExpiredError rebuild(void Function(TokenExpiredErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TokenExpiredErrorBuilder toBuilder() =>
      new TokenExpiredErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TokenExpiredError &&
        code == other.code &&
        message == other.message;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, code.hashCode), message.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TokenExpiredError')
          ..add('code', code)
          ..add('message', message))
        .toString();
  }
}

class TokenExpiredErrorBuilder
    implements Builder<TokenExpiredError, TokenExpiredErrorBuilder> {
  _$TokenExpiredError? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  ListBuilder<TokenExpiredErrorMessage>? _message;
  ListBuilder<TokenExpiredErrorMessage> get message =>
      _$this._message ??= new ListBuilder<TokenExpiredErrorMessage>();
  set message(ListBuilder<TokenExpiredErrorMessage>? message) =>
      _$this._message = message;

  TokenExpiredErrorBuilder();

  TokenExpiredErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _message = $v.message.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TokenExpiredError other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TokenExpiredError;
  }

  @override
  void update(void Function(TokenExpiredErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TokenExpiredError build() => _build();

  _$TokenExpiredError _build() {
    _$TokenExpiredError _$result;
    try {
      _$result = _$v ??
          new _$TokenExpiredError._(code: code, message: message.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'message';
        message.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'TokenExpiredError', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$TokenExpiredErrorMessage extends TokenExpiredErrorMessage {
  @override
  final String? tokenClass;
  @override
  final String? tokenType;
  @override
  final String? message;

  factory _$TokenExpiredErrorMessage(
          [void Function(TokenExpiredErrorMessageBuilder)? updates]) =>
      (new TokenExpiredErrorMessageBuilder()..update(updates))._build();

  _$TokenExpiredErrorMessage._({this.tokenClass, this.tokenType, this.message})
      : super._();

  @override
  TokenExpiredErrorMessage rebuild(
          void Function(TokenExpiredErrorMessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TokenExpiredErrorMessageBuilder toBuilder() =>
      new TokenExpiredErrorMessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TokenExpiredErrorMessage &&
        tokenClass == other.tokenClass &&
        tokenType == other.tokenType &&
        message == other.message;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, tokenClass.hashCode), tokenType.hashCode),
        message.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TokenExpiredErrorMessage')
          ..add('tokenClass', tokenClass)
          ..add('tokenType', tokenType)
          ..add('message', message))
        .toString();
  }
}

class TokenExpiredErrorMessageBuilder
    implements
        Builder<TokenExpiredErrorMessage, TokenExpiredErrorMessageBuilder> {
  _$TokenExpiredErrorMessage? _$v;

  String? _tokenClass;
  String? get tokenClass => _$this._tokenClass;
  set tokenClass(String? tokenClass) => _$this._tokenClass = tokenClass;

  String? _tokenType;
  String? get tokenType => _$this._tokenType;
  set tokenType(String? tokenType) => _$this._tokenType = tokenType;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  TokenExpiredErrorMessageBuilder();

  TokenExpiredErrorMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tokenClass = $v.tokenClass;
      _tokenType = $v.tokenType;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TokenExpiredErrorMessage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TokenExpiredErrorMessage;
  }

  @override
  void update(void Function(TokenExpiredErrorMessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TokenExpiredErrorMessage build() => _build();

  _$TokenExpiredErrorMessage _build() {
    final _$result = _$v ??
        new _$TokenExpiredErrorMessage._(
            tokenClass: tokenClass, tokenType: tokenType, message: message);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
