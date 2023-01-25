import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../go_router_helper/routes.dart';
import '../../utils/app_state_provider/provider.dart';
import '../../widgets/text_view.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  @override
  Widget build(BuildContext context) {
    final AppState _appState = AppState.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const TextView(
          text: 'SignIn',
          color: Colors.white,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextView(text: 'Else Sign with:'),
            IconButton(
              onPressed: () {
              _appState.smsStreamRepo.getPermission();
                context.go('/${AppRoutes.signin.path}/${AppRoutes.phoneAuthenticationForm.path}');
              },
              icon: const Icon(
                Icons.phone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
