import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:yatru_sewa/blocs/blocs.dart';
import 'package:yatru_sewa/blocs/search_routes_bloc/search_routes_bloc.dart';
import 'package:yatru_sewa/logger.dart';
import 'package:yatru_sewa/provider.dart';
import 'package:yatru_sewa/routes/routes.dart';
import 'package:yatru_sewa/routes/search_route.dart';
import 'package:yatru_sewa/shared/clients/api_client.dart';

import 'package:yatru_sewa/shared/shared.dart';

class LoginInfo extends ChangeNotifier {
  var _userName = '';
  String get userName => _userName;
  bool get loggedIn => _userName.isNotEmpty;

  void login(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void logout() {
    _userName = '';
    notifyListeners();
  }
}

Future main() async {

  final logger = Logger();
  const secureStorage = FlutterSecureStorage();
  final initialAccessToken = await secureStorage.read(key: Keys.accessTokenKey);
  final initialRefreshToken = await secureStorage.read(key: Keys.refreshTokenKey);
  final sessionRepository = SessionCubit(
    initialAccessToken,
    initialRefreshToken,
    secureStorage,
  );

  final apiClient = ApiClient(
    host: '127.0.0.1',
    port: 8000,
    initialAccessToken: initialAccessToken,
    getAccessToken: sessionRepository.getAccessToken,
    getRefreshToken: sessionRepository.getRefreshToken,
    setAccessToken: sessionRepository.setAccessToken,
  );

  final searchRoutesBloc = SearchRoutesBloc(apiClient);

  final appState = AppState(
    apiClient: apiClient,
    session: sessionRepository,
    searchRoutesBloc: searchRoutesBloc,
  );
  final blocObserver = AppBlocObserver(appState, logger);

  FlutterError.onError = (details) {
    logger.logFlutterError(details, blocObserver.current);
  };

  // BlocOverrides.runZoned(
  //   () async {
  //     WidgetsFlutterBinding.ensureInitialized();
  //     runApp(
  //       MainApp(
  //         key: const Key('MainApp'),
  //         appState: appState,
  //       ),
  //     );
  //   },
  //   blocObserver: blocObserver,
  // );

  BlocOverrides.runZoned(
    () => runZonedGuarded(
      () {
        WidgetsFlutterBinding.ensureInitialized();
        return MainApp(
          key: const Key('MainApp'),
          appState: appState,
        );
      },
      (error, stackTrace) {
        logger.logError(error, stackTrace, blocObserver.current);
      },
    ),
    blocObserver: blocObserver,
  );

  // runZonedGuarded(
  //   () => BlocOverrides.runZoned(
  //     () async {
  //       WidgetsFlutterBinding.ensureInitialized();
  //       return MainApp(
  //         key: const Key('MainApp'),
  //         appState: appState,
  //       );
  //     },
  //     blocObserver: blocObserver
  //   ),
  //   (error, stackTrace) {
  //     logger.logError(error, stackTrace, blocObserver.current);
  //   },
  // );

  // BlocOverrides.runZoned(
  //   () async {

  //     WidgetsFlutterBinding.ensureInitialized();
  //     final widget = runZonedGuarded(
  //       () => MainApp(
  //         key: const Key('MainApp'),
  //         appState: appState,
  //       ),
  //       (error, stackTrace) => logger.logError(error, stackTrace, blocObserver.current),
  //     );

  //     return runApp(
  //       widget!,
  //     );
  //   },
  //   blocObserver: blocObserver,
  // );
}

class MainApp extends StatefulWidget {
  const MainApp({
    Key? key,
    required this.appState,
  }) : super(key: key);

  final AppState appState;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  final List<String> guestRoutes = guestRoutePaths.map((e) => '/$e').toList();

  late final _router = GoRouter(
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        path: HomeRoute.routePath,
        builder: (_, state) => const HomeRoute(key: Key('Home')),
        routes: [
          GoRoute(
            path: LoginRoute.routePath,
            builder: (_, state) => LoginRoute(
                key: const Key('Login'),
                apiClient: widget.appState.apiClient,
              ),
          ),
          GoRoute(
            path: SearchRoute.routePath,
            builder: (_, state) => SearchRoute(
              apiClient: widget.appState.apiClient,
            ),
          ),
        ],
      ),
    ],
    // redirect to the login page if the user is not logged in
    redirect: (state) {

      const loginRoute = '/${LoginRoute.routePath}';
      final isTryingToLogin = guestRoutes.contains(state.subloc);

      if (!widget.appState.session.isLoggedIn) {
  
        return isTryingToLogin ? null : loginRoute;
      }

      return isTryingToLogin ? '/' : null;
    },
  );

  @override
  Widget build(BuildContext context) {

    return AppStateProvider(
      appState: widget.appState,
      child: BlocProvider(
        create: (_) => widget.appState.session,
        child: MaterialApp.router(
          routerDelegate: _router.routerDelegate,
          routeInformationParser: _router.routeInformationParser,
          routeInformationProvider: _router.routeInformationProvider,
        ),
      ),
    );
  }
}
