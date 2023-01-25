// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_form_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LoginFormData> _$loginFormDataSerializer =
    new _$LoginFormDataSerializer();
Serializer<LoginSuccessData> _$loginSuccessDataSerializer =
    new _$LoginSuccessDataSerializer();

class _$LoginFormDataSerializer implements StructuredSerializer<LoginFormData> {
  @override
  final Iterable<Type> types = const [LoginFormData, _$LoginFormData];
  @override
  final String wireName = 'LoginFormData';

  @override
  Iterable<Object?> serialize(Serializers serializers, LoginFormData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'password',
      serializers.serialize(object.password,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  LoginFormData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LoginFormDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'password':
          result.password = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$LoginSuccessDataSerializer
    implements StructuredSerializer<LoginSuccessData> {
  @override
  final Iterable<Type> types = const [LoginSuccessData, _$LoginSuccessData];
  @override
  final String wireName = 'LoginSuccessData';

  @override
  Iterable<Object?> serialize(Serializers serializers, LoginSuccessData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'access_token',
      serializers.serialize(object.accessToken,
          specifiedType: const FullType(String)),
      'refresh_token',
      serializers.serialize(object.refreshToken,
          specifiedType: const FullType(String)),
      'user',
      serializers.serialize(object.user, specifiedType: const FullType(User)),
    ];

    return result;
  }

  @override
  LoginSuccessData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LoginSuccessDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'access_token':
          result.accessToken = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'refresh_token':
          result.refreshToken = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'user':
          result.user.replace(serializers.deserialize(value,
              specifiedType: const FullType(User))! as User);
          break;
      }
    }

    return result.build();
  }
}

class _$LoginFormData extends LoginFormData {
  @override
  final String email;
  @override
  final String password;

  factory _$LoginFormData([void Function(LoginFormDataBuilder)? updates]) =>
      (new LoginFormDataBuilder()..update(updates))._build();

  _$LoginFormData._({required this.email, required this.password}) : super._() {
    BuiltValueNullFieldError.checkNotNull(email, r'LoginFormData', 'email');
    BuiltValueNullFieldError.checkNotNull(
        password, r'LoginFormData', 'password');
  }

  @override
  LoginFormData rebuild(void Function(LoginFormDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginFormDataBuilder toBuilder() => new LoginFormDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginFormData &&
        email == other.email &&
        password == other.password;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, email.hashCode), password.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginFormData')
          ..add('email', email)
          ..add('password', password))
        .toString();
  }
}

class LoginFormDataBuilder
    implements Builder<LoginFormData, LoginFormDataBuilder> {
  _$LoginFormData? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  LoginFormDataBuilder();

  LoginFormDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginFormData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LoginFormData;
  }

  @override
  void update(void Function(LoginFormDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginFormData build() => _build();

  _$LoginFormData _build() {
    final _$result = _$v ??
        new _$LoginFormData._(
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'LoginFormData', 'email'),
            password: BuiltValueNullFieldError.checkNotNull(
                password, r'LoginFormData', 'password'));
    replace(_$result);
    return _$result;
  }
}

class _$LoginSuccessData extends LoginSuccessData {
  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final User user;

  factory _$LoginSuccessData(
          [void Function(LoginSuccessDataBuilder)? updates]) =>
      (new LoginSuccessDataBuilder()..update(updates))._build();

  _$LoginSuccessData._(
      {required this.accessToken,
      required this.refreshToken,
      required this.user})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        accessToken, r'LoginSuccessData', 'accessToken');
    BuiltValueNullFieldError.checkNotNull(
        refreshToken, r'LoginSuccessData', 'refreshToken');
    BuiltValueNullFieldError.checkNotNull(user, r'LoginSuccessData', 'user');
  }

  @override
  LoginSuccessData rebuild(void Function(LoginSuccessDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginSuccessDataBuilder toBuilder() =>
      new LoginSuccessDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginSuccessData &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        user == other.user;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, accessToken.hashCode), refreshToken.hashCode),
        user.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginSuccessData')
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken)
          ..add('user', user))
        .toString();
  }
}

class LoginSuccessDataBuilder
    implements Builder<LoginSuccessData, LoginSuccessDataBuilder> {
  _$LoginSuccessData? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  LoginSuccessDataBuilder();

  LoginSuccessDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _refreshToken = $v.refreshToken;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginSuccessData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LoginSuccessData;
  }

  @override
  void update(void Function(LoginSuccessDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginSuccessData build() => _build();

  _$LoginSuccessData _build() {
    _$LoginSuccessData _$result;
    try {
      _$result = _$v ??
          new _$LoginSuccessData._(
              accessToken: BuiltValueNullFieldError.checkNotNull(
                  accessToken, r'LoginSuccessData', 'accessToken'),
              refreshToken: BuiltValueNullFieldError.checkNotNull(
                  refreshToken, r'LoginSuccessData', 'refreshToken'),
              user: user.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'LoginSuccessData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
