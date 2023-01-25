part of 'search_routes_bloc.dart';

abstract class SearchRoutesEvent extends Equatable {
  const SearchRoutesEvent();

  @override
  List<Object?> get props => [];
}

class StartRoutesSearch extends SearchRoutesEvent {

  final String query;

  const StartRoutesSearch(this.query);

  @override
  List<Object?> get props => [query];
}
