import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatru_sewa/blocs/forms/login_form/login_form_bloc.dart';
import 'package:yatru_sewa/forms/login_form.dart';
import 'package:yatru_sewa/routes/routes.dart';
import 'package:yatru_sewa/shared/clients/api_client.dart';
import 'package:yatru_sewa/shared/repositories/session_storage_repository.dart';

class LoginRoute extends StatelessWidget {

  static const String routePath = 'login';
  static const String route = '/$routePath';

  final String redirectRoute;
  final ApiClient apiClient;


  const LoginRoute({
    Key? key,
    required this.apiClient,
    this.redirectRoute = HomeRoute.routePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final loginFormBloc = LoginFormBloc(
      context.read<SessionCubit>(),
      apiClient
    );
    return Scaffold(
      appBar: AppBar(
        // ignore: todo
        // TODO: restrict user to go home by using redirect
        leading: const SizedBox(),
        title: const Text('Login to Yatrusewa'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocProvider(
            create: (context) => loginFormBloc,
            child: LoginForm(
              redirectRoute: redirectRoute,
            ),
          ),
        ),
      ),
    );
  }
}
