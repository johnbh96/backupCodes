import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yatru_sewa/provider.dart';
import 'package:yatru_sewa/shared/clients/api_client.dart';
import 'package:yatru_sewa/shared/repositories/session_storage_repository.dart';

class HomeRoute extends StatelessWidget {

  static const String routePath = '/';

  const HomeRoute({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final session = AppState.of(context).session;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              child: const Text('Search Routes'),
              onPressed: () async {
                router.go('/routes');
              },
            ),
            const SizedBox(height: 120,),
            OutlinedButton(
              child: const Text('Log Out'),
              onPressed: () async {
                await session.deleteCredentials();
                router.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}