import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/auth/login.dart';
import '../pages/home_page/my_home_page.dart';
import '../pages/welcome_screen.dart';
import '../utils/app_state_provider/provider.dart';
import 'routes.dart';

class AppRouter {
  final AppState appState;
  AppRouter({
    required this.appState,
  });

  GoRouter get router => _router;
  String _storedPath = '';
  late final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.home.path,
    debugLogDiagnostics: true,
    refreshListenable: appState.sessionBloc,
    routes: <GoRoute>[
      GoRoute(
        path: AppRoutes.home.path,
        name: AppRoutes.home.name,
        builder: (
          BuildContext context,
          GoRouterState state,
        ) {
          return const MyHomePage();
        },
        routes: <GoRoute>[
          GoRoute(
            path: AppRoutes.login.path,
            name: AppRoutes.login.name,
            builder: (
              BuildContext context,
              GoRouterState state,
            ) {
              return const Login();
            }
          ),
          GoRoute(
            path: AppRoutes.welcomeScreen.path,
            name: AppRoutes.welcomeScreen.name,
            builder: (
              BuildContext context,
              GoRouterState state,
            ) {
              return const OnBoarding();
            }
          ),
        ],
      ),
    ],
    redirect: (GoRouterState state) {
      final String loginLocation = AppRoutes.login.path;
      final String homeLocation = AppRoutes.home.path;
      final String onboardLocation = AppRoutes.welcomeScreen.path;

      final bool isLoggedIn = appState.session.isLoggedIn;
      final bool hasOnboarded = appState.sharedPrefs.isWelcomeScreenShown;

      final bool isGoingToOnboard = state.subloc == '/$onboardLocation';
      final bool isGoingToLogin = state.subloc == '/$loginLocation';

      if(state.location != homeLocation){
        _storedPath = state.location;
      }

      if(!hasOnboarded && !isGoingToOnboard){
        return homeLocation + onboardLocation;
      } else if(!isLoggedIn && hasOnboarded && !isGoingToLogin){
        return homeLocation + loginLocation;
      } else if ((isLoggedIn && (hasOnboarded && !isGoingToOnboard)) && state.location != homeLocation){
        if(_storedPath.isNotEmpty){
          return _storedPath;
        } else {
          return homeLocation;
        }
      }
      return null;
    },
    errorBuilder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Image(
            image: const NetworkImage('https://wallpaperboat.com/wp-content/uploads/2020/12/03/62926/error-404-10.jpg'),
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.orangeAccent,
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
