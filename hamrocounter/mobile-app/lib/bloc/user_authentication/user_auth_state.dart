part of 'user_auth_bloc.dart';

abstract class UserAuthState extends Equatable {
  const UserAuthState();
  @override
  List<Object> get props => <Object>[];
}

class UnknownState extends UserAuthState {
  final String message;
  const UnknownState({this.message = ''});
}

class Authenticated extends UserAuthState{
  final String message;
  const Authenticated({this.message = ''});

  @override
  List<Object> get props => <Object>[];
}

class UnAuthenticated extends UserAuthState {
  final String message;
  const UnAuthenticated({this.message = ''});
}
