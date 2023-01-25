import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatru_sewa/shared/clients/api_client.dart';
import 'package:yatru_sewa/shared/exceptions.dart';
import 'package:yatru_sewa/shared/models/login_form_data.dart';
import 'package:yatru_sewa/shared/repositories/session_storage_repository.dart';

part 'login_form_event.dart';
part 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {

  final ApiClient apiClient;
  final SessionCubit session;

  LoginFormBloc(this.session, this.apiClient) : super(const LoginFormReady()) {
    on<SubmitLoginForm>(_onFormSubmit);
  }

  Future _onFormSubmit(SubmitLoginForm event, Emitter<LoginFormState> emitter) async {

    try {
      emit(const LoginFormInProgress());
      final loginRespData = await apiClient.login(event.data);
      await session.setCredentials(loginRespData.accessToken, loginRespData.refreshToken);
      emit(LoginFormSuccess(loginRespData.user.pk));
    } on NetworkException catch(e) {
      emit(LoginFormFailed(e.userMessage));
    } on NotFound catch(e) {
      emit(LoginFormFailed(e.userMessage));
    }
  }
}