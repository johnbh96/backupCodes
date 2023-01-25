import 'package:flutter/widgets.dart';

import '../../bloc/notifications/notifications_bloc.dart';
import '../../bloc/user_authentication/user_auth_bloc.dart';
import '../../go_router_helper/route_helper_class.dart';
import '../clients/api_clients.dart';
import '../repositories/remote_config_repository.dart';
import '../repositories/session_storage_repositories.dart';
import '../repositories/sms_receiver_repository.dart';
import '../shared_prefs/shared_prefs.dart';

class AppState {
  final ApiClient apiClient;
  final SessionStorageRepositories session;
  final AppRouter appRouter;
  final NotificationsBloc notifications;
  final UserAuthBloc userAuthenticationBloc;
  final SharedPrefs sharedPrefs;
  final RemoteConfigRepository remoteConfigRepositories;
  final SmsStreamRepository smsStreamRepo;

  AppState({
    required this.apiClient,
    required this.session,
    required this.notifications,
    required this.userAuthenticationBloc,
    required this.sharedPrefs,
    required this.remoteConfigRepositories,
    required this.smsStreamRepo,
    required this.appRouter,
  }) {
    remoteConfigRepositories.getRemoteConfigValue();
    userAuthenticationBloc.add(const ListenUserStateChange());
    notifications.add(const ListenNotifications());
  }

  static AppState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStateProvider>()!
        .appState;
  }
}

class AppStateProvider extends InheritedWidget {
  final AppState appState;

  const AppStateProvider({
    Key? key,
    required Widget child,
    required this.appState,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
