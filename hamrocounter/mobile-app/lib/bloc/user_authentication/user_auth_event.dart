part of 'user_auth_bloc.dart';

abstract class UserAuthenticationEvent extends Equatable {
  const UserAuthenticationEvent();

  @override
  List<Object> get props => <Object>[];
}

class FirebasePhoneAuthentication extends UserAuthenticationEvent{
  final String userPhoneNumber;
  const FirebasePhoneAuthentication({required this.userPhoneNumber});

  @override
  List<Object> get props => <Object>[userPhoneNumber];
}

class VerifyPhoneNumber extends UserAuthenticationEvent{
  final String otp;
  const VerifyPhoneNumber({required this.otp});

  @override
  List<Object> get props => <Object>[otp];
}

class LogoutUser extends UserAuthenticationEvent{
  const LogoutUser();
}

class ListenUserStateChange extends UserAuthenticationEvent{
  const ListenUserStateChange();
}
