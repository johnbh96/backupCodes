import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:yatru_sewa/blocs/forms/login_form/login_form_bloc.dart';
import 'package:yatru_sewa/shared/models/login_form_data.dart';
import 'package:yatru_sewa/shared/shared.dart';

class LoginForm extends StatelessWidget {

  static LoginFormData fromRawValue(Map<String, Object?> rawValue) {
    return LoginFormData((b) => b
      ..email = rawValue['email'] as String
      ..password = rawValue['password'] as String,
    );
  }

  final String redirectRoute;

  final formGroup = FormGroup({
    'email': FormControl<String>(
      validators: [
        Validators.required,
        Validators.email,
      ]
    ),
    'password': FormControl<String>(
      validators: [
        Validators.required,
      ]
    ),
  });

  LoginForm({super.key, required this.redirectRoute});

  @override
  Widget build(BuildContext context) {

    final sessionRepository = context.read<SessionCubit>();
    final router = GoRouter.of(context);
    final loginFormBloc = context.read<LoginFormBloc>();

    final formContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReactiveTextField(
          formControlName: 'email',
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
        ),
        ReactiveTextField(
          formControlName: 'password',
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12.0),
          child: ReactiveFormConsumer(
            builder: (context, form, child) {

              return OutlinedButton(
                onPressed: !form.valid ? null : () async {
                  // login
                  loginFormBloc.add(SubmitLoginForm(
                    LoginForm.fromRawValue(form.rawValue),
                  ));
                },
                child: const Text('Login'),
              );
            },
          ),
        )
      ],
    );
    final formBuilder = ReactiveFormBuilder(
      child: formContent,
      form: () => formGroup ,
      builder: (context, form, child) {

        return formContent;
      },
    );
    return BlocListener<LoginFormBloc, LoginFormState>(
      listener: (context, state) {

        if (state is LoginFormSuccess) {
          router.go(redirectRoute);
        } else if (state is LoginFormFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              backgroundColor: Colors.black,
            ),
          );
        }
      },
      child: formBuilder,
    );
  }

}