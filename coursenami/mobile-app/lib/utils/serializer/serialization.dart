import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

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
])
final Serializers serializers = (
  _$serializers.toBuilder()
  ..addBuilderFactory(const FullType(BuiltList,<FullType>[FullType(TokenExpiredErrorMessage)]), () => ListBuilder<TokenExpiredErrorMessage>())
  ..addPlugin(StandardJsonPlugin())
).build();
