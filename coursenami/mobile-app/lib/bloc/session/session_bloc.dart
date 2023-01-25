import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../../models/user/user_model.dart';
import '../../utils/exceptions/exception.dart';
import '../../utils/repositories/session_storage_repositories.dart';
import '../../utils/repositories/user_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> with ChangeNotifier {
  final SessionStorageRepositories sessionStorageRepositories;
  final UserRepository userRepository;
  final FirebaseAuth firebaseAuthInstance;

  SessionBloc({
    required this.sessionStorageRepositories,
    required this.userRepository,
    required this.firebaseAuthInstance,
  }) : super(const SessionUnknown()) {
    on<LoadSession>(_loadSession);
    on<LoginSession>(login);
  }

  Future<void> login(LoginSession event, Emitter<SessionState> emit) async{
    // final UserModel user = await userRepository.getUser();
    sessionStorageRepositories.setCredentials('some-access-token','some-refresh-token');
    emit(SessionPresent(event.loginCode));
    notifyListeners();
  }

  Future<void> _loadSession(LoadSession event, Emitter<SessionState> emit) async{
    try{
      final String? accessToken = await sessionStorageRepositories.getAccessToken();
      final String? refreshToken = await sessionStorageRepositories.getRefreshToken();

      if (accessToken == null || refreshToken == null){
        if(state == const SessionAbsent()){
          return;
        }
        emit(const SessionAbsent());
        notifyListeners();
        // await firebaseAuthInstance.signInAnonymously();
        return;
      }

      final UserModel user = await userRepository.getUser();
      emit(SessionPresent(user.pk));
      notifyListeners();
    }on SessionExpired catch(e, _){
      emit(const SessionAbsent());
      await sessionStorageRepositories.deleteCredentials();
      // await firebaseAuthInstance.signInAnonymously();
      notifyListeners();
    }on NetworkException catch(e, _){
      notifyListeners();
      emit(const SessionAbsent());
      throw NetworkException(message: e.toString());
    }
  }
}
