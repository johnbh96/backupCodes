import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../utils/keys/keys.dart';
import '../../utils/repositories/session_storage_repositories.dart';

part 'user_auth_event.dart';
part 'user_auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthenticationEvent, UserAuthState> with ChangeNotifier{
  final FirebaseAuth firebaseAuthInstance;
  final FlutterSecureStorage secureStorage;
  final SessionStorageRepositories sessionRepositories;

  UserAuthBloc({
    required this.firebaseAuthInstance,
    required this.secureStorage,
    required this.sessionRepositories,
  }) : super(const UnknownState()) {
    on<FirebasePhoneAuthentication>(_phoneNumberVerification);
    on<VerifyPhoneNumber>(_userAuthentication);
    on<LogoutUser>(_logoutUser);
    on<ListenUserStateChange>(_listeningUserStateChange);
  }

  String _verificationCode = '';

  // TODO(Atom): Fix it
  Future<void> _listeningUserStateChange(ListenUserStateChange event, Emitter<UserAuthState> emit) async {
    if (await sessionRepositories.getUserId()){
      emit(const UnAuthenticated());
      notifyListeners();
    }else{
      emit(const Authenticated());
      notifyListeners();
    }
  }

  Future<void> _phoneNumberVerification(FirebasePhoneAuthentication event, Emitter<UserAuthState> emit) async{
    if (event.userPhoneNumber.length == 10){
      await firebaseAuthInstance.verifyPhoneNumber(
        phoneNumber: '+977${event.userPhoneNumber}',
        verificationCompleted:(PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: _handleException,
        codeSent:(String verificationId, int? forceResendingToken) {
         if (verificationId.isNotEmpty){
            _verificationCode = verificationId;
         }
        },
        codeAutoRetrievalTimeout:(String verificationId) {}
      );
    }else{
      emit(const UnknownState());
      emit(const UnAuthenticated(message: 'Please input valid number'));
    }
  }

  void _handleException(FirebaseException error){
    final String errorCode = error.code;
    if (errorCode == 'invalid-phone-number'){
      throw FirebaseException(plugin: error.toString());
    }
  }

  Future<void> _userAuthentication(VerifyPhoneNumber event, Emitter<UserAuthState> emit) async {
    final PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: _verificationCode,
      smsCode: event.otp,
    );

    await firebaseAuthInstance.signInWithCredential(phoneAuthCredential)
    .then((UserCredential userCredential) async {
      if (!userCredential.user!.isAnonymous){
        emit(const Authenticated(message: 'Signin Successful'));
        await sessionRepositories.setUserId(userCredential.user!.uid);
        notifyListeners();
      }
    }).onError((Object? error, StackTrace stackTrace) {
      emit(const UnAuthenticated(message: 'Please enter valid credentials.'));
      emit(const UnknownState());
      notifyListeners();
    });
  }

  Future<void> _logoutUser(LogoutUser event, Emitter<UserAuthState> emit) async {
    await secureStorage.delete(key: Keys.userIdKey);
    await firebaseAuthInstance.signOut();
    emit(const UnAuthenticated(message: 'Logged Out'));
    notifyListeners();
  }

  // TODO(Atom): For our company we need a unqiue regexp for otp.
  String? getOtp({required AsyncSnapshot<dynamic> snapShot}){
    final String message= snapShot.data.toString();
    if (snapShot.hasData){
      final bool isOtpValid = message.substring(0,6).contains(RegExp(r'[^0-9]'));
      if (isOtpValid){
        return '';
      }{
        final String sms = message.substring(0, 6);
        return sms;
      }
    }else{
      return '';
    }
  }
}
