import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'user.dart';

part 'login_form_data.g.dart';

abstract class LoginFormData implements Built<LoginFormData, LoginFormDataBuilder> {
  LoginFormData._();

  factory LoginFormData([Function(LoginFormDataBuilder b) updates]) = _$LoginFormData;

  String get email;
  String get password;

  static Serializer<LoginFormData> get serializer => _$loginFormDataSerializer;
}

abstract class LoginSuccessData
    implements Built<LoginSuccessData, LoginSuccessDataBuilder> {
  LoginSuccessData._();

  factory LoginSuccessData([Function(LoginSuccessDataBuilder b) updates]) = _$LoginSuccessData;

  @BuiltValueField(wireName: 'access_token')
  String get accessToken;
  @BuiltValueField(wireName: 'refresh_token')
  String get refreshToken;
  @BuiltValueField(wireName: 'user')
  User get user;

  static Serializer<LoginSuccessData> get serializer => _$loginSuccessDataSerializer;
}
