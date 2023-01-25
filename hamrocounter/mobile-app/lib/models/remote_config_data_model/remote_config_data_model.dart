import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'remote_config_data_model.g.dart';

abstract class UserTypeConfig implements Built<UserTypeConfig, UserTypeConfigBuilder>{
  // TODO(atom): This is just for demo which act as a flag and will change in future
  @BuiltValueField(wireName: 'usertype')
  String? get userType;
  String? get layout;
  bool? get wishes;

  factory UserTypeConfig([Function(UserTypeConfigBuilder b) updates]) = _$UserTypeConfig;
  UserTypeConfig._();
  static Serializer<UserTypeConfig> get serializer => _$userTypeConfigSerializer;
}
