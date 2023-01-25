import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'my_app.dart';
import 'utils/app_state_provider/provider.dart';
import 'utils/bootstrap/main_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final AppState appState = await mainBootstrap();
  runApp(MyApp(
    appState: appState,
  ));
}
