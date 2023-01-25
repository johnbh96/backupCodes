part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();
  
  @override
  List<Object> get props => <Object>[];
}


class NoNotification extends NotificationsState {}

class NotificationReceived extends NotificationsState {
  final String message;

  const NotificationReceived(this.message);
}
