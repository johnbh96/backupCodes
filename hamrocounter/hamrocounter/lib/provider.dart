import 'package:flutter/material.dart';
import 'package:yatru_sewa/blocs/search_routes_bloc/search_routes_bloc.dart';
import 'package:yatru_sewa/shared/clients/api_client.dart';
import 'package:yatru_sewa/shared/repositories/session_storage_repository.dart';

class AppState {

  final ApiClient apiClient;
  final SessionCubit session;

  final SearchRoutesBloc searchRoutesBloc;

  AppState({
    required this.apiClient,
    required this.session,
    required this.searchRoutesBloc,
  });

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>()!.appState;
  }
}

class AppStateProvider extends InheritedWidget {

  final AppState appState;

  const AppStateProvider({
    super.key,
    required this.appState,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // ignore: todo
    // TODO: update on theme change
    return false;
  }
}
