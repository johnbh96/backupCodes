part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => []; 
}

class LoadSession extends SessionEvent {
  const LoadSession();
}
