part of 'login_form_bloc.dart';

abstract class LoginFormEvent extends Equatable {

  const LoginFormEvent();

  @override
  List<Object?> get props => [];
}

class SubmitLoginForm extends LoginFormEvent {

  final LoginFormData data;

  const SubmitLoginForm(this.data);

  @override
  List<Object?> get props => [];
}
