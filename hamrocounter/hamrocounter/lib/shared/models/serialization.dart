import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/serializer.dart';
import 'package:yatru_sewa/shared/models/login_form_data.dart';

import 'models.dart';

part 'serialization.g.dart';

@SerializersFor([
  TokenExpiredErrorMessage,
  TokenExpiredError,
  AccessToken,
  RefreshToken,
  LoginFormData,
  LoginSuccessData,
  RoutePoint,
  Route,
])
final Serializers serializers = (
  _$serializers.toBuilder()
  ..addBuilderFactory(
    const FullType(BuiltList, [FullType(TokenExpiredErrorMessage)]),
    () => ListBuilder<TokenExpiredErrorMessage>(),
  )
  ..addBuilderFactory(
    const FullType(BuiltList, [FullType(Route)]),
    () => ListBuilder<Route>(),
  )
  ..addPlugin(StandardJsonPlugin())
)
.build();
