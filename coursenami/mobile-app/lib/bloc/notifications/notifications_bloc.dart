import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final Stream<RemoteMessage> firebaseMessaging;
  NotificationsBloc({
    required this.firebaseMessaging,
  }) : super(NoNotification()) {
    on<ListenNotifications>(notifyUser);
  }

  Future<void> notifyUser(ListenNotifications event, Emitter<NotificationsState> emit) async {
    firebaseMessaging.listen((RemoteMessage message) {
      log(message.data.toString());
      emit(NotificationReceived(message.toString()));
      if (message.notification != null){
        log(message.notification.toString());
      }
    });
  }
}
