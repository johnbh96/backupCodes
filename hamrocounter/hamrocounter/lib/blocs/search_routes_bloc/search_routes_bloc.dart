import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatru_sewa/blocs/blocs.dart';
import 'package:yatru_sewa/shared/clients/api_client.dart';
import 'package:yatru_sewa/shared/exceptions.dart';
import 'package:yatru_sewa/shared/models/models.dart';

part 'search_routes_state.dart';
part 'search_routes_event.dart';

class SearchRoutesBloc extends AppBloc<SearchRoutesEvent, SearchRoutesState> {

  final ApiClient apiClient;

  SearchRoutesBloc(this.apiClient) : super('searchRoutes', const SearchRoutesReady()) {
    on<StartRoutesSearch>(_onSearchRoute);
  }

  Future _onSearchRoute(StartRoutesSearch event, Emitter<SearchRoutesState> emitter) async {

    try {
      emit(const SearchRoutesInProgress());
      final searchResult = await apiClient.get<BuiltList<Route>>(path: 'search/vehicle/routes');
      emit(SearchRoutesSuccess(searchResult));
    } on NetworkException catch (e) {
      emit(SearchRoutesFailed(e.userMessage));
    }
  }
}
