import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:fake_firebase_remote_config/fake_firebase_remote_config.dart';
import 'package:flutter_hamrocounter/utils/enums/enum_collections.dart';
import 'package:flutter_hamrocounter/utils/repositories/remote_config_repository.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async{
  late RemoteConfigRepository sut;
  late FakeRemoteConfig mockRemoteConfig;

  const String parameterKey = 'user_type_config';

  final Map<String, dynamic> remoteValueVip = <String, dynamic>{
    parameterKey : json.encode(<Map<String, dynamic>>[
      <String, dynamic>{'usertype':'VIP','layout':'Blue','wishes':true},
      <String, dynamic>{'usertype':'VIP','layout':'Green','wishes':true},
      <String, dynamic>{'usertype':'Normal','layout':'Green','wishes':false},
      <String, dynamic>{'usertype':'Normal','layout':'Blue','wishes':false}
    ],
  )};

  final Map<String, dynamic> remoteValueNormal = <String, dynamic>{
    parameterKey : json.encode(<Map<String, dynamic>>[
      <String, dynamic>{'usertype':'Normal','layout':'Blue','wishes':false},
      <String, dynamic>{'usertype':'Normal','layout':'Green','wishes':false},
      <String, dynamic>{'usertype':'Normal','layout':'Green','wishes':false},
      <String, dynamic>{'usertype':'Normal','layout':'Blue','wishes':false}
    ],
  )};

  final String defaultValue = json.encode(
     <Map<String, dynamic>>[
      <String, dynamic>{
        'usertype': UserType.normal.toString(),
        'layout':'Blue',
        'wishes': true
      },
    ],
  );

  setUp((){
    mockRemoteConfig = FakeRemoteConfig();
    sut = RemoteConfigRepository(
      remoteConfig: mockRemoteConfig,
    );
  });

  blocTest<RemoteConfigRepository, UserType>('Emit [UserType.vip] when the index 0 wishes field is true',
    setUp: () async {
      await mockRemoteConfig.setDefaults(<String, dynamic>{parameterKey : defaultValue});
      mockRemoteConfig.loadMockData(remoteValueVip);
      await mockRemoteConfig.fetchAndActivate();
    },

    build: () => sut,
    act: (RemoteConfigRepository bloc) => sut.getRemoteConfigValue(),
    expect: (){
      return <UserType>[
        UserType.vip,
      ];
    }
  );

  blocTest<RemoteConfigRepository, UserType>('Emit [UserType.normal] when the index 1 wishes field is false',
      setUp: () async {
        await mockRemoteConfig.setDefaults(<String, dynamic>{parameterKey : defaultValue});
        mockRemoteConfig.loadMockData(remoteValueNormal);
        await mockRemoteConfig.fetchAndActivate();
      },
      build: () => sut,
      act: (RemoteConfigRepository bloc) => sut.getRemoteConfigValue(),
      expect: (){
        return <UserType>[
          UserType.normal,
        ];
      }
    );
}
