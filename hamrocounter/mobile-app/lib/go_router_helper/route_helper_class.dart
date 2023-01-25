import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../bloc/user_authentication/user_auth_bloc.dart';
import '../pages/home_page/my_home_page.dart';
import '../pages/signin_page/components/otp_verification_form.dart';
import '../pages/signin_page/components/phone_authentication_form.dart';
import '../pages/signin_page/signin_page.dart';
import '../pages/welcome_screen.dart';
import '../utils/repositories/router_utils.dart';

import '../utils/shared_prefs/shared_prefs.dart';
import 'routes.dart';

class AppRouter {
  final SharedPrefs sharedPrefs;
  final UserAuthBloc userAuthBloc;
  final RouterUtils routerUtils;
  AppRouter({
    required this.sharedPrefs,
    required this.userAuthBloc,
    required this.routerUtils,
  });

  GoRouter get router => _router;
  String _storedPath = '';

  late final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.home.path,
    debugLogDiagnostics: true,
    refreshListenable: routerUtils,
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
            path: AppRoutes.welcomeScreen.path,
            name: AppRoutes.welcomeScreen.name,
            builder: (
              BuildContext context,
              GoRouterState state,
            ) {
              return const OnBoarding();
            },
          ),
          GoRoute(
            path: AppRoutes.signin.path,
            name: AppRoutes.signin.name,
            builder: (
              BuildContext context,
              GoRouterState state,
            ) {
              return const SigninPage();
            },
            routes: <GoRoute>[
              GoRoute(
                path: AppRoutes.phoneAuthenticationForm.path,
                name: AppRoutes.phoneAuthenticationForm.name,
                builder: (
                  BuildContext context,
                  GoRouterState state,
                ) {
                  return const PhoneAuthenticationForm();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: AppRoutes.phoneVerificationForm.path,
                    name: AppRoutes.phoneVerificationForm.name,
                    builder: (
                      BuildContext context,
                      GoRouterState state,
                    ){
                      return const OtpVerificationForm();
                    }
                  )
                ]
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: redirect,
    errorBuilder: (BuildContext context, GoRouterState state) {
      return const Material(
          child: Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colors.orangeAccent,
        ),
      ));
    },
  );

  String? redirect(GoRouterState state) {
    final String loginLocation = AppRoutes.signin.path;
    final String homeLocation = AppRoutes.home.path;
    final String onboardLocation = AppRoutes.welcomeScreen.path;

    final bool isLoggedIn = routerUtils.isLoggedInController.value;
    final bool hasOnboarded = sharedPrefs.welcomeScreenData.value;

    final bool isGoingToOnboard = state.subloc == '/$onboardLocation';
    final bool isGoingToLogin = state.subloc == '/$loginLocation';

    if (state.location != homeLocation) {
      _storedPath = state.location;
    }

    if (!hasOnboarded && !isGoingToOnboard) {
      return homeLocation + onboardLocation;
    } else if (!isLoggedIn && hasOnboarded && !isGoingToLogin) {
      return homeLocation + loginLocation;
    } else if ((isLoggedIn && (hasOnboarded && !isGoingToOnboard)) &&
        state.location != homeLocation) {
      if (_storedPath.isNotEmpty) {
        return _storedPath;
      } else {
        return homeLocation;
      }
    }
    return null;
  }
}
