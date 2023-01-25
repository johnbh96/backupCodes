import 'package:flutter/widgets.dart';

import '../../bloc/notifications/notifications_bloc.dart';
import '../../bloc/session/session_bloc.dart';
import '../clients/api_clients.dart';
import '../repositories/session_storage_repositories.dart';
import '../shared_prefs/shared_prefs.dart';

class AppState{
  final ApiClient apiClient;
  final SessionStorageRepositories session;
  final SessionBloc sessionBloc;
  final NotificationsBloc notifications;
  final SharedPrefs sharedPrefs;

  AppState({
    required this.apiClient,
    required this.session,
    required this.sessionBloc,
    required this.notifications,
    required this.sharedPrefs,
  }){
    sessionBloc.add(const LoadSession());
    notifications.add(const ListenNotifications());
  }

  static AppState of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>()!.appState;
  }
}

class AppStateProvider extends InheritedWidget{
  final AppState appState;

  const AppStateProvider({
    Key? key,
    required Widget child,
    required this.appState,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
