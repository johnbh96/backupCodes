import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'bloc/onboarding/onboarding_cubit.dart';
import 'bloc/user_authentication/user_auth_bloc.dart';
import 'go_router_helper/route_helper_class.dart';
import 'utils/app_state_provider/provider.dart';
import 'utils/repositories/remote_config_repository.dart';
import 'utils/repositories/router_utils.dart';
import 'utils/repositories/session_storage_repositories.dart';
import 'package:gallery/components/font.dart';

class MyApp extends StatefulWidget {
  final AppState appState;
  // final AppRouter appRouter;
  // final RouterUtils utils;
  const MyApp({
    Key? key,
    required this.appState,
    // required this.appRouter,
    // required this.utils,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String titleMain = 'hamrocounter';
  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      appState: widget.appState,
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<OnBoardingCubit>(
            create: (BuildContext context) =>
                OnBoardingCubit(sharedPrefs: widget.appState.sharedPrefs),
          ),
          BlocProvider<UserAuthBloc>(
              create: (BuildContext context) =>
                  widget.appState.userAuthenticationBloc),
          BlocProvider<RemoteConfigRepository>(
            create: (BuildContext context) =>
                widget.appState.remoteConfigRepositories,
          ),
        ],
        child: ReactiveFormConfig(
          validationMessages: <String, String Function(Object)>{
            ValidationMessage.required: (Object error) => 'Required',
          },
          child: MaterialApp.router(
            builder: (BuildContext context, Widget? child) {
              return child!;
            },
            routeInformationParser:
                widget.appState.appRouter.router.routeInformationParser,
            routerDelegate: widget.appState.appRouter.router.routerDelegate,
            routeInformationProvider:
                widget.appState.appRouter.router.routeInformationProvider,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: SFProText,
            ),
            title: titleMain,
          ),
        ),
      ),
    );
  }
}
