part of 'login_form_bloc.dart';

abstract class LoginFormState extends Equatable {

  const LoginFormState();

  @override
  List<Object?> get props => []; 
}

class LoginFormReady extends LoginFormState {

  const LoginFormReady();
}

class LoginFormInProgress extends LoginFormState {

  const LoginFormInProgress();
}

class LoginFormFailed extends LoginFormState {
  
  final String message;

  const LoginFormFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginFormSuccess extends LoginFormState {

  final int userId;

  const LoginFormSuccess(this.userId);

  @override
  List<Object?> get props => [userId];
}
