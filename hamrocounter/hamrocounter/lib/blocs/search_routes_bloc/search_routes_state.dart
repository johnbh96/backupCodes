part of 'search_routes_bloc.dart';

abstract class SearchRoutesState extends Equatable {
  const SearchRoutesState();

  @override
  List<Object?> get props => [];
}

class SearchRoutesReady extends SearchRoutesState {
  const SearchRoutesReady();
}

class SearchRoutesInProgress extends SearchRoutesState {
  const SearchRoutesInProgress();
}

class SearchRoutesSuccess extends SearchRoutesState {

  final BuiltList<Route> routes;

  const SearchRoutesSuccess(this.routes);

  @override
  List<Object?> get props => [routes];
}

class SearchRoutesFailed extends SearchRoutesState {
  
  final String userMessage;

  const SearchRoutesFailed(this.userMessage);
}
