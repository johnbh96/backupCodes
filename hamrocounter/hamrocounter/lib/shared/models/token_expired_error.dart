import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'token_expired_error.g.dart';

abstract class TokenExpiredError implements Built<TokenExpiredError, TokenExpiredErrorBuilder> {
  TokenExpiredError._();

  factory TokenExpiredError([Function(TokenExpiredErrorBuilder b) updates]) = _$TokenExpiredError;

  String? get code;
  BuiltList<TokenExpiredErrorMessage> get messages;

  static Serializer<TokenExpiredError> get serializer => _$tokenExpiredErrorSerializer;
}

abstract class TokenExpiredErrorMessage implements Built<TokenExpiredErrorMessage, TokenExpiredErrorMessageBuilder> {
  TokenExpiredErrorMessage._();

  factory TokenExpiredErrorMessage([Function(TokenExpiredErrorMessageBuilder b) updates]) = _$TokenExpiredErrorMessage;

  @BuiltValueField(wireName: 'token_class')
  String? get tokenClass;
  @BuiltValueField(wireName: 'token_type')
  String? get tokenType;
  String? get message;

  static Serializer<TokenExpiredErrorMessage> get serializer => _$tokenExpiredErrorMessageSerializer;
}
