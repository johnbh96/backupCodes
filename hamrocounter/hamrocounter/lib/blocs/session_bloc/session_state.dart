part of 'session_bloc.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => []; 
}

class SessionUnknown extends SessionState {
  const SessionUnknown();
}

class SessionLoading extends SessionState {
  const SessionLoading();
}

class SessionLoadError extends SessionState {
  const SessionLoadError();
}

class SessionAbsent extends SessionState {
  const SessionAbsent();
}

class SessionPresent extends SessionState {

  final int userId;

  const SessionPresent(this.userId);

  @override
  List<Object?> get props => [userId];
}
