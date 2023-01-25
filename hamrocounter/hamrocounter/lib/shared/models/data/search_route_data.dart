import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_route_data.g.dart';

abstract class RoutePoint implements Built<RoutePoint, RoutePointBuilder> {

  RoutePoint._();

  factory RoutePoint([Function(RoutePointBuilder b) updates]) = _$RoutePoint;

  String get name;

  static Serializer<RoutePoint> get serializer => _$routePointSerializer;
}

abstract class Route implements Built<Route, RouteBuilder> {

  Route._();

  factory Route([Function(RouteBuilder b) updates]) = _$Route;

  int get id;
  @BuiltValueField(wireName: 'start_point')
  RoutePoint get startPoint;
  @BuiltValueField(wireName: 'end_point')
  RoutePoint get endPoint;

  static Serializer<Route> get serializer => _$routeSerializer;
}
