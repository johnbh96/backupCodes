// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_route_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RoutePoint> _$routePointSerializer = new _$RoutePointSerializer();
Serializer<Route> _$routeSerializer = new _$RouteSerializer();

class _$RoutePointSerializer implements StructuredSerializer<RoutePoint> {
  @override
  final Iterable<Type> types = const [RoutePoint, _$RoutePoint];
  @override
  final String wireName = 'RoutePoint';

  @override
  Iterable<Object?> serialize(Serializers serializers, RoutePoint object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  RoutePoint deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RoutePointBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$RouteSerializer implements StructuredSerializer<Route> {
  @override
  final Iterable<Type> types = const [Route, _$Route];
  @override
  final String wireName = 'Route';

  @override
  Iterable<Object?> serialize(Serializers serializers, Route object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'start_point',
      serializers.serialize(object.startPoint,
          specifiedType: const FullType(RoutePoint)),
      'end_point',
      serializers.serialize(object.endPoint,
          specifiedType: const FullType(RoutePoint)),
    ];

    return result;
  }

  @override
  Route deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RouteBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'start_point':
          result.startPoint.replace(serializers.deserialize(value,
              specifiedType: const FullType(RoutePoint))! as RoutePoint);
          break;
        case 'end_point':
          result.endPoint.replace(serializers.deserialize(value,
              specifiedType: const FullType(RoutePoint))! as RoutePoint);
          break;
      }
    }

    return result.build();
  }
}

class _$RoutePoint extends RoutePoint {
  @override
  final String name;

  factory _$RoutePoint([void Function(RoutePointBuilder)? updates]) =>
      (new RoutePointBuilder()..update(updates))._build();

  _$RoutePoint._({required this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'RoutePoint', 'name');
  }

  @override
  RoutePoint rebuild(void Function(RoutePointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoutePointBuilder toBuilder() => new RoutePointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoutePoint && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc(0, name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoutePoint')..add('name', name))
        .toString();
  }
}

class RoutePointBuilder implements Builder<RoutePoint, RoutePointBuilder> {
  _$RoutePoint? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RoutePointBuilder();

  RoutePointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoutePoint other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RoutePoint;
  }

  @override
  void update(void Function(RoutePointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoutePoint build() => _build();

  _$RoutePoint _build() {
    final _$result = _$v ??
        new _$RoutePoint._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'RoutePoint', 'name'));
    replace(_$result);
    return _$result;
  }
}

class _$Route extends Route {
  @override
  final int id;
  @override
  final RoutePoint startPoint;
  @override
  final RoutePoint endPoint;

  factory _$Route([void Function(RouteBuilder)? updates]) =>
      (new RouteBuilder()..update(updates))._build();

  _$Route._(
      {required this.id, required this.startPoint, required this.endPoint})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Route', 'id');
    BuiltValueNullFieldError.checkNotNull(startPoint, r'Route', 'startPoint');
    BuiltValueNullFieldError.checkNotNull(endPoint, r'Route', 'endPoint');
  }

  @override
  Route rebuild(void Function(RouteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteBuilder toBuilder() => new RouteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Route &&
        id == other.id &&
        startPoint == other.startPoint &&
        endPoint == other.endPoint;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, id.hashCode), startPoint.hashCode), endPoint.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Route')
          ..add('id', id)
          ..add('startPoint', startPoint)
          ..add('endPoint', endPoint))
        .toString();
  }
}

class RouteBuilder implements Builder<Route, RouteBuilder> {
  _$Route? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  RoutePointBuilder? _startPoint;
  RoutePointBuilder get startPoint =>
      _$this._startPoint ??= new RoutePointBuilder();
  set startPoint(RoutePointBuilder? startPoint) =>
      _$this._startPoint = startPoint;

  RoutePointBuilder? _endPoint;
  RoutePointBuilder get endPoint =>
      _$this._endPoint ??= new RoutePointBuilder();
  set endPoint(RoutePointBuilder? endPoint) => _$this._endPoint = endPoint;

  RouteBuilder();

  RouteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _startPoint = $v.startPoint.toBuilder();
      _endPoint = $v.endPoint.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Route other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Route;
  }

  @override
  void update(void Function(RouteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Route build() => _build();

  _$Route _build() {
    _$Route _$result;
    try {
      _$result = _$v ??
          new _$Route._(
              id: BuiltValueNullFieldError.checkNotNull(id, r'Route', 'id'),
              startPoint: startPoint.build(),
              endPoint: endPoint.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'startPoint';
        startPoint.build();
        _$failedField = 'endPoint';
        endPoint.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Route', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
