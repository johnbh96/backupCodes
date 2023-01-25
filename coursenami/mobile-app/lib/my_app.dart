import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/onboarding/onboarding_cubit.dart';
import 'bloc/session/session_bloc.dart';
import 'go_router_helper/route_helper_class.dart';
import 'utils/app_state_provider/provider.dart';
import 'utils/repositories/session_storage_repositories.dart';

class MyApp extends StatefulWidget {
  final AppState appState;
  final AppRouter appRouter;
  const MyApp({
    Key? key,
    required this.appState,
    required this.appRouter,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String titleMain = 'Coursenami';

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      appState: widget.appState,
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<SessionStorageRepositories>(
            create: (BuildContext context) => widget.appState.session,
          ),
          BlocProvider<SessionBloc>(
            create: (BuildContext context) => widget.appState.sessionBloc
          ),
          BlocProvider<OnBoardingCubit>(
            create: (BuildContext context) => OnBoardingCubit(sharedPrefs: widget.appState.sharedPrefs),
          )
        ],
        child: MaterialApp.router(
          builder: (BuildContext context, Widget? child) {
            return child!;
          },
          routeInformationParser: widget.appRouter.router.routeInformationParser,
          routerDelegate: widget.appRouter.router.routerDelegate,
          routeInformationProvider:
              widget.appRouter.router.routeInformationProvider,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          title: titleMain,
        ),
      ),
    );
  }
}
