part of 'session_bloc.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object> get props => <Object>[];
}

class SessionUnknown extends SessionState {
  const SessionUnknown();
}

class SessionAbsent extends SessionState{
  const SessionAbsent();
}

class SessionPresent extends SessionState{
  final int userId;
  const SessionPresent(this.userId);

  @override
  List<Object> get props => <Object>[userId];
}
