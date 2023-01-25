import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yatru_sewa/blocs/search_routes_bloc/search_routes_bloc.dart';
import 'package:yatru_sewa/provider.dart';
import 'package:yatru_sewa/routes/routes.dart';
import 'package:yatru_sewa/shared/clients/api_client.dart';

class SearchRoute extends StatelessWidget {

  static const String routePath = 'routes';
  static const String route = '/$routePath';

  final String redirectRoute;
  final ApiClient apiClient;


  const SearchRoute({
    Key? key,
    required this.apiClient,
    this.redirectRoute = HomeRoute.routePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final router = GoRouter.of(context);
    final searchRoutesBloc = AppState.of(context).searchRoutesBloc;
    return BlocProvider(
      create: (_) => searchRoutesBloc,
      child: Scaffold(
        appBar: AppBar(
          // ignore: todo
          // TODO: restrict user to go home by using redirect
          leading: const SizedBox(),
          title: const Text('Search Routes'),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: OutlinedButton(
                child: const Text('Go Back'),
                onPressed: () {
                  searchRoutesBloc.add(const StartRoutesSearch('query'));
                  router.pop();
                },
              ),
          ),
        ),
      ),
    );
  }
}
