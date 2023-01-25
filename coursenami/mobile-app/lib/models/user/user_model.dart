import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_model.g.dart';

abstract class UserModel implements Built<UserModel, UserModelBuilder>{
  int get pk;
  String? get username;
  String get email;
  @BuiltValueField(wireName: 'first_name')
  String? get firstName;
  @BuiltValueField(wireName: 'last_name')
  String? get lastName;

  factory UserModel([Function(UserModelBuilder b) updates]) = _$UserModel;
  UserModel._();
  static Serializer<UserModel> get serializer => _$userModelSerializer;
}
