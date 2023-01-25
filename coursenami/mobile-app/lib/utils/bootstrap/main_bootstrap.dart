import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/base_bloc.dart';
import '../../bloc/notifications/notifications_bloc.dart';
import '../../bloc/session/session_bloc.dart';
import '../app_state_provider/provider.dart';
import '../clients/api_clients.dart';
import '../keys/keys.dart';
import '../logger/logger.dart';
import '../repositories/session_storage_repositories.dart';
import '../repositories/user_repository.dart';
import '../shared_prefs/shared_prefs.dart';

Future<AppState> mainBootstrap() async{
  final Stream<RemoteMessage> _firebaseMessaging = FirebaseMessaging.onMessage;
  final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;

  final Logger _logger = Logger();
  const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final String? initialAccessToken = await _secureStorage.read(key: Keys.accessTokenKey);
  final String? initialRefreshToken = await _secureStorage.read(key: Keys.refreshTokenKey);

  final SessionStorageRepositories _sessionRepositories = SessionStorageRepositories(
    initialAccessToken,
    initialRefreshToken,
    _secureStorage,
  );

  final ApiClient _apiClient = ApiClient(
    host: '127.0.0.1',
    initialAccessToken: initialAccessToken,
    getAccessToken: _sessionRepositories.getAccessToken,
    getRefreshToken: _sessionRepositories.getRefreshToken,
    setAccessToken: _sessionRepositories.setAccessToken
  );

  final UserRepository _userRepository = UserRepository(apiClient: _apiClient);

  final SessionBloc _sessionBloc = SessionBloc(
    sessionStorageRepositories: _sessionRepositories,
    userRepository: _userRepository,
    firebaseAuthInstance: _firebaseAuthInstance,
  );

  final SharedPreferences _sharedPreferencesInstance = await SharedPreferences.getInstance();

  final SharedPrefs _sharedPrefs = SharedPrefs(
    sharedPreferences: _sharedPreferencesInstance
  );

  final NotificationsBloc _listenNotifications = NotificationsBloc(firebaseMessaging: _firebaseMessaging);

  final AppState appState = AppState(
    apiClient: _apiClient,
    session: _sessionRepositories,
    sessionBloc: _sessionBloc,
    notifications: _listenNotifications,
    sharedPrefs: _sharedPrefs,
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
