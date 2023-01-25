import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {
  User._();

  factory User([updates(UserBuilder b)]) = _$User;

  @BuiltValueField(wireName: 'pk')
  int get pk;
  @BuiltValueField(wireName: 'username')
  String? get username;
  @BuiltValueField(wireName: 'email')
  String get email;
  @BuiltValueField(wireName: 'first_name')
  String? get firstName;
  @BuiltValueField(wireName: 'last_name')
  String? get lastName;

  static Serializer<User> get serializer => _$userSerializer;
}
