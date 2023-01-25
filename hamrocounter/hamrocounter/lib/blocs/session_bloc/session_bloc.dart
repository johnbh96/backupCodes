import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatru_sewa/shared/exceptions.dart';
import 'package:yatru_sewa/shared/repositories/session_storage_repository.dart';
import 'package:yatru_sewa/shared/repositories/user_repository.dart';

part 'session_state.dart';
part 'session_event.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {

  final SessionCubit sessionStorageRepository;
  final UserRepository userRepository;

  SessionBloc({
    required this.sessionStorageRepository,
    required this.userRepository,
  }) : super(const SessionUnknown()) {
    on<LoadSession>(_loadSession);
  }


  Future _loadSession(LoadSession event, Emitter<SessionState> emit) async {

    try {
      emit(const SessionLoading());
      final accessToken = await sessionStorageRepository.getAccessToken();
      final refreshToken = await sessionStorageRepository.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        emit(const SessionAbsent());
        return;
      }

      final user = await userRepository.getUser();
      emit(SessionPresent(user.pk));
    } on SessionExpired catch (e, _) {
      await sessionStorageRepository.deleteCredentials();
      emit(const SessionAbsent());
    } on NetworkException catch(e, _) {
      emit(const SessionLoadError());
    }
  }
}