part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadSession extends SessionEvent{
  const LoadSession();
}

class LoginSession extends SessionEvent{
  final int loginCode;
  const LoginSession(this.loginCode);
}
