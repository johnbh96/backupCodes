import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_tokens.g.dart';

abstract class AccessToken implements Built<AccessToken, AccessTokenBuilder> {
  AccessToken._();

  factory AccessToken([updates(AccessTokenBuilder b)]) = _$AccessToken;

  @BuiltValueField(wireName: 'access')
  String get access;
  @BuiltValueField(wireName: 'access_token_expiration')
  String get accessTokenExpiration;

  static Serializer<AccessToken> get serializer => _$accessTokenSerializer;
}

abstract class RefreshToken
    implements Built<RefreshToken, RefreshTokenBuilder> {
  RefreshToken._();

  factory RefreshToken([updates(RefreshTokenBuilder b)]) = _$RefreshToken;

  @BuiltValueField(wireName: 'refresh')
  String? get refreshToken;

  static Serializer<RefreshToken> get serializer => _$refreshTokenSerializer;
}
