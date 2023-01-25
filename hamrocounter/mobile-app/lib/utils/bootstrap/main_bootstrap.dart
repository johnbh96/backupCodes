import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hamrocounter/utils/repositories/router_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/base_bloc.dart';
import '../../bloc/notifications/notifications_bloc.dart';
import '../../bloc/user_authentication/user_auth_bloc.dart';
import '../../go_router_helper/route_helper_class.dart';
import '../app_state_provider/provider.dart';
import '../clients/api_clients.dart';
import '../keys/keys.dart';
import '../logger/logger.dart';
import '../repositories/remote_config_repository.dart';
import '../repositories/session_storage_repositories.dart';
import '../repositories/sms_receiver_repository.dart';
import '../shared_prefs/shared_prefs.dart';

Future<AppState> mainBootstrap() async {
  final Stream<RemoteMessage> _firebaseMessaging = FirebaseMessaging.onMessage;
  final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  RemoteConfigSettings(
      fetchTimeout: const Duration(hours: 12),
      minimumFetchInterval: const Duration(hours: 1));

  final Logger _logger = Logger();
  const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final String? initialAccessToken =
      await _secureStorage.read(key: Keys.accessTokenKey);
  final String? initialRefreshToken =
      await _secureStorage.read(key: Keys.refreshTokenKey);

  final SessionStorageRepositories _sessionRepositories =
      SessionStorageRepositories(
    initialAccessToken,
    initialRefreshToken,
    _secureStorage,
  );

  final ApiClient _apiClient = ApiClient(
      host: '127.0.0.1',
      initialAccessToken: initialAccessToken,
      getAccessToken: _sessionRepositories.getAccessToken,
      getRefreshToken: _sessionRepositories.getRefreshToken,
      setAccessToken: _sessionRepositories.setAccessToken);

  final SharedPreferences _sharedPreferencesInstance =
      await SharedPreferences.getInstance();

  final SharedPrefs _sharedPrefs =
      SharedPrefs(sharedPreferences: _sharedPreferencesInstance);

  final NotificationsBloc _listenNotifications =
      NotificationsBloc(firebaseMessaging: _firebaseMessaging);

  final SmsStreamRepository _smsStreamRepo = SmsStreamRepository();

  final UserAuthBloc _userAuthenticationBloc = UserAuthBloc(
    firebaseAuthInstance: _firebaseAuthInstance,
    secureStorage: _secureStorage,
    sessionRepositories: _sessionRepositories,
  );

  final RemoteConfigRepository _remoteConfigRepository = RemoteConfigRepository(
    remoteConfig: _remoteConfig,
  );

  final RouterUtils utils =
      RouterUtils(sharedPrefs: _sharedPrefs, storage: _sessionRepositories);
  final AppRouter appRouter = AppRouter(
    sharedPrefs: _sharedPrefs,
    userAuthBloc: _userAuthenticationBloc,
    routerUtils: utils,
  );

  final AppState appState = AppState(
    apiClient: _apiClient,
    session: _sessionRepositories,
    notifications: _listenNotifications,
    sharedPrefs: _sharedPrefs,
    userAuthenticationBloc: _userAuthenticationBloc,
    remoteConfigRepositories: _remoteConfigRepository,
    smsStreamRepo: _smsStreamRepo,
    appRouter: appRouter,
  );

  final AppBlocObserver _blocObserver = AppBlocObserver(
    appState,
    _logger,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    _logger.logFlutterError(details, _blocObserver.current);
  };

  return appState;
}
