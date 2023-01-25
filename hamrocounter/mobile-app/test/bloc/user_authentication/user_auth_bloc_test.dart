import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_hamrocounter/bloc/user_authentication/user_auth_bloc.dart';
import 'package:flutter_hamrocounter/utils/keys/keys.dart';
import 'package:flutter_hamrocounter/utils/repositories/session_storage_repositories.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}
class MockSessionStroage extends Mock implements SessionStorageRepositories {
}

Future<void> main() async{
  late UserAuthBloc sut;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockSecureStorage mockSecureStorage;
  late MockSessionStroage mockSessionRepositories;
  late PhoneAuthCredential credential;

  const String _phoneNumber = '(9846357158)';  // The number from reactiveform is within the bracket
  const String _actualPhoneNumber = '+9779846357158';
  const String _smsCode = '(123456)';
  const String _verificationId = 'verificationId';

  final MockUser loggedInUser = MockUser(
    isAnonymous: false,
    displayName: 'test',
    uid: 'uid',
    phoneNumber: _actualPhoneNumber,
    email: 'test@test.com',
  );

  setUp((){
    mockSecureStorage = MockSecureStorage();
    mockSessionRepositories = MockSessionStroage();
    mockFirebaseAuth = MockFirebaseAuth(mockUser: loggedInUser);

    credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _smsCode
    );
    sut = UserAuthBloc(
      firebaseAuthInstance: mockFirebaseAuth,
      secureStorage: mockSecureStorage,
      sessionRepositories: mockSessionRepositories,
    );
  });

  test('Check initial state', (){
    expect(sut.state, const UnknownState());
  });

  group('ListenUserStateChange event test', (){
    blocTest<UserAuthBloc, UserAuthState>(
      '''emit [Authenticated] when user flutter secure storage is not null''',
      setUp: () async {
        await mockFirebaseAuth.signInWithCredential(credential);
        when(() => mockSessionRepositories.getUserId()).thenAnswer((Invocation _) async {
          return Future<bool>.value(false);
        });
      },

      build: () => sut,

      act: (UserAuthBloc bloc) => bloc.add(const ListenUserStateChange()),

      expect: () {
        return <UserAuthState>[
          const Authenticated(),
        ];
      });

      blocTest<UserAuthBloc, UserAuthState>(
        '''emit [UnAuthenticated] when user id null''',
        setUp: () async {
          when(() => mockSessionRepositories.getUserId()).thenAnswer((Invocation _) async {
            return Future<bool>.value(true);
          });
        },
        build: () => sut,

        act: (UserAuthBloc bloc) => bloc.add(const ListenUserStateChange()),

        expect: () {
          return <UserAuthState>[
            const UnAuthenticated(),
        ];
      });
    });

    group('Phone authentication', (){
      blocTest<UserAuthBloc, UserAuthState>(
        'emit [ AuthInProgress ] when user provide the valid  phonenumber.',
        build: () => sut,
        act: (UserAuthBloc bloc) => bloc.add(const FirebasePhoneAuthentication(
          userPhoneNumber: _phoneNumber)
        ),
        expect: (){
          return <UserAuthState>[
            const UnknownState(),
          ];
        }
      );

      blocTest<UserAuthBloc, UserAuthState>(
        'emit [ Unknown, UnAuthenticated  ] when given phone number is invalid.',
        build: () => sut,
        act: (UserAuthBloc bloc) => bloc.add(const FirebasePhoneAuthentication(
          userPhoneNumber: '$_phoneNumber+abcd')
        ),
        expect: (){
          return <UserAuthState>[
            const UnknownState(),
            const UnAuthenticated(),
          ];
        }
      );
    });

    group('User Authentication', (){
      blocTest<UserAuthBloc, UserAuthState>(
        'emit [Authenticate] when user provide proper phone credential.',
        setUp: ()  {
          when(() => mockSessionRepositories.setUserId('uid')).thenAnswer((Invocation _) async {return;});
        },
        build: () => sut,
        act: (UserAuthBloc bloc) => bloc.add(const VerifyPhoneNumber(otp: _smsCode)),
        expect: (){
          return <UserAuthState>[
            const Authenticated(),
          ];
        }
      );
    });

    blocTest<UserAuthBloc, UserAuthState>(
      'Logout User',
      setUp: () async {
        when(() => mockSecureStorage.delete(key: Keys.userIdKey)).thenAnswer((Invocation _) async {return;});
      },
      build: () => sut,
      act: (UserAuthBloc bloc) => bloc.add(const LogoutUser()),
      expect: (){
        return <UserAuthState>[
          const UnAuthenticated(),
        ];
      }
    );

  }
