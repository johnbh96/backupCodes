// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_data_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserTypeConfig> _$userTypeConfigSerializer =
    new _$UserTypeConfigSerializer();

class _$UserTypeConfigSerializer
    implements StructuredSerializer<UserTypeConfig> {
  @override
  final Iterable<Type> types = const [UserTypeConfig, _$UserTypeConfig];
  @override
  final String wireName = 'UserTypeConfig';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserTypeConfig object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.userType;
    if (value != null) {
      result
        ..add('usertype')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.layout;
    if (value != null) {
      result
        ..add('layout')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.wishes;
    if (value != null) {
      result
        ..add('wishes')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  UserTypeConfig deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserTypeConfigBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'usertype':
          result.userType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'layout':
          result.layout = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'wishes':
          result.wishes = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
      }
    }

    return result.build();
  }
}

class _$UserTypeConfig extends UserTypeConfig {
  @override
  final String? userType;
  @override
  final String? layout;
  @override
  final bool? wishes;

  factory _$UserTypeConfig([void Function(UserTypeConfigBuilder)? updates]) =>
      (new UserTypeConfigBuilder()..update(updates))._build();

  _$UserTypeConfig._({this.userType, this.layout, this.wishes}) : super._();

  @override
  UserTypeConfig rebuild(void Function(UserTypeConfigBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserTypeConfigBuilder toBuilder() =>
      new UserTypeConfigBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserTypeConfig &&
        userType == other.userType &&
        layout == other.layout &&
        wishes == other.wishes;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, userType.hashCode), layout.hashCode), wishes.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserTypeConfig')
          ..add('userType', userType)
          ..add('layout', layout)
          ..add('wishes', wishes))
        .toString();
  }
}

class UserTypeConfigBuilder
    implements Builder<UserTypeConfig, UserTypeConfigBuilder> {
  _$UserTypeConfig? _$v;

  String? _userType;
  String? get userType => _$this._userType;
  set userType(String? userType) => _$this._userType = userType;

  String? _layout;
  String? get layout => _$this._layout;
  set layout(String? layout) => _$this._layout = layout;

  bool? _wishes;
  bool? get wishes => _$this._wishes;
  set wishes(bool? wishes) => _$this._wishes = wishes;

  UserTypeConfigBuilder();

  UserTypeConfigBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userType = $v.userType;
      _layout = $v.layout;
      _wishes = $v.wishes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserTypeConfig other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserTypeConfig;
  }

  @override
  void update(void Function(UserTypeConfigBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserTypeConfig build() => _build();

  _$UserTypeConfig _build() {
    final _$result = _$v ??
        new _$UserTypeConfig._(
            userType: userType, layout: layout, wishes: wishes);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
