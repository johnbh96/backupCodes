import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/remote_config_data_model/remote_config_data_model.dart';
import '../enums/enum_collections.dart';
import '../serializer/serialization.dart';

class RemoteConfigRepository extends Cubit<UserType>{
  final FirebaseRemoteConfig remoteConfig;

  RemoteConfigRepository({
    required this.remoteConfig,
  }) : super(UserType.normal);

  String parameterKey = 'user_type_config';


  Future<void> getRemoteConfigValue () async {
    await _setDefaultRemoteConfigValue();

    final RemoteConfigValue remoteConfigData = remoteConfig.getValue(
      parameterKey,
    );

    final BuiltList<UserTypeConfig> responseData = listResponseSerializer<UserTypeConfig>(remoteConfigData.asString());
    switch(responseData[0].wishes){
      case true:
        emit(UserType.vip);
        break;
      default:
        emit(UserType.normal);
        break;
    }
  }

  Future<void> _setDefaultRemoteConfigValue() async {
    final  String defaultValue = json.encode(
     <Map<String, Object>>[
        <String, Object>{
        'usertype': UserType.normal.toString(),
        'layout':'Blue',
        'wishes': true
      }]
    );

    await remoteConfig.setDefaults(<String, dynamic>{parameterKey: defaultValue});
    await remoteConfig.fetchAndActivate();
  }
}
