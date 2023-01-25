import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_tokens.g.dart';

abstract class AccessToken implements Built<AccessToken, AccessTokenBuilder>{
  String get access;
  @BuiltValueField(wireName: 'access_token_expiration')
  String get accessTokenExpiration;

  factory AccessToken([Function(AccessTokenBuilder b) updates]) = _$AccessToken;
  AccessToken._();
  static Serializer<AccessToken> get serializer => _$accessTokenSerializer;
}

abstract class RefreshToken implements Built<RefreshToken, RefreshTokenBuilder>{
  @BuiltValueField(wireName: 'refresh')
  String? get refreshToken; 

  factory RefreshToken([Function(RefreshTokenBuilder b) updates]) = _$RefreshToken;
  RefreshToken._();
  static Serializer<RefreshToken> get serializer => _$refreshTokenSerializer;
}
