import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import '../../models/remote_config_data_model/remote_config_data_model.dart';
import '../../models/session_tokens/session_tokens.dart';
import '../../models/token_expired_error/token_expired_error.dart';
import '../../models/user/user_model.dart';

part 'serialization.g.dart';

@SerializersFor(<Type>[
  TokenExpiredError,
  TokenExpiredErrorMessage,
  AccessToken,
  RefreshToken,
  UserModel,
  UserTypeConfig,
])
final Serializers serializers = (
  _$serializers.toBuilder()
  ..addBuilderFactory(const FullType(BuiltList,<FullType>[FullType(TokenExpiredErrorMessage)]), () => ListBuilder<TokenExpiredErrorMessage>())
  ..addPlugin(StandardJsonPlugin())
).build();

BuiltList<T> listResponseSerializer<T>(String body){
  final Iterable<T> iterable = (json.decode(body) as Iterable<dynamic>).map<T>((dynamic value){
    return serializers.deserialize(value, specifiedType: FullType(T)) as T;
  });

  final BuiltList<T> items = BuiltList<T>.from(iterable.toList());
  return items;
}
