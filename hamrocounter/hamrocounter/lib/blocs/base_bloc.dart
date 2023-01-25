import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatru_sewa/logger.dart';
import 'package:yatru_sewa/provider.dart';

abstract class AppBloc<E, S> extends Bloc<E, S> {

  AppBloc(id, super.initialState);


  late final String id;

  @override
  String toString() {
    return '$runtimeType:\n\t$state';
  }
}

class AppBlocObserver implements BlocObserver {

  final AppState appState;
  final Logger logger;
  final List<AppBloc> registeredBlocs = [];

  AppBlocObserver(this.appState, this.logger);

  @override
  void onChange(BlocBase bloc, Change change) {}

  @override
  void onClose(BlocBase bloc) {
    if (bloc is AppBloc) {
      final blocIndex = registeredBlocs.indexWhere((element) => element.id == bloc.id);
      debugPrint('Removed bloc: $bloc');
      registeredBlocs.removeAt(blocIndex);
    }
  }

  @override
  void onCreate(BlocBase bloc) {
    if (bloc is AppBloc) {
      final blocExists = registeredBlocs.any((element) => element.id == bloc.id);
      if (blocExists) {
        throw ArgumentError('Bloc with id ${bloc.id} is already registered', 'Duplicate Bloc Id');
      }
      debugPrint('Registered bloc: $bloc');
      registeredBlocs.add(bloc);
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.logError(error, stackTrace, current);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {}

  @override
  void onTransition(Bloc bloc, Transition transition) {}

  String get current => ([
    appState.apiClient,
    appState.session,
    appState.searchRoutesBloc,
  ] + registeredBlocs).map((e) => e.toString()).join('\n');
}
