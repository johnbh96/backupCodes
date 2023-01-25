import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/app_state_provider/provider.dart';
import '../utils/logger/logger.dart';

abstract class AppBloc<E, S> extends Bloc<E, S>{
  AppBloc(S initialState, this.id) : super(initialState);
  late final String id;

  @override
  String toString(){
    return '$runtimeType:\n\t$state';
  }
}

class AppBlocObserver implements BlocObserver{
  final AppState appState;
  final Logger logger;

  final List<AppBloc<dynamic, dynamic>> registeredBlocs = <AppBloc<dynamic, dynamic>>[];

  AppBlocObserver(this.appState, this.logger);

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {}

  @override
  void onClose(BlocBase<dynamic> bloc) { 
    if (bloc is AppBloc){
      final int blocIndex = registeredBlocs.indexWhere((
        AppBloc<dynamic, dynamic>element) => element.id == bloc.id
      );
      debugPrint('Removed bloc: $bloc');
      registeredBlocs.removeAt(blocIndex);
    }
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    if (bloc is AppBloc){
      final bool blocExists = registeredBlocs.any((
        AppBloc<dynamic, dynamic>element) => element.id == bloc.id
      );
      if (blocExists){
        throw ArgumentError('Bloc with id ${bloc.id} is already registered', 'Duplicate Bloc Id');
      }
      debugPrint('Registred bloc: $bloc');
      registeredBlocs.add(bloc);
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.logError(error, stackTrace, current);
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {}

  String get current => (<Object>[
    appState.apiClient,
    appState.session,
  ] + registeredBlocs).map((Object e) => e.toString()).join('\n');
}
