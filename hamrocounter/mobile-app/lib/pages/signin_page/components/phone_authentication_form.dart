import 'package:flutter/material.dart';
import 'component.dart';

class PhoneAuthenticationForm extends StatefulWidget {
  const PhoneAuthenticationForm({Key? key}) : super(key: key);

  @override
  State<PhoneAuthenticationForm> createState() => _PhoneAuthenticationFormState();
}

class _PhoneAuthenticationFormState extends State<PhoneAuthenticationForm> {
  @override
  Widget build(BuildContext context) {
    final AppState appState = AppState.of(context);

    final FormGroup formGroupForPhoneAuth = FormGroup(<String, AbstractControl<String>>{
      'phoneNumber' : FormControl<String>(
        validators: <Map<String, dynamic>? Function(AbstractControl<dynamic>)>[
          Validators.required,
          Validators.pattern(RegularExpression.nepalPhonePattern),
          Validators.minLength(10),
          Validators.maxLength(10),
        ]
      ),
    });

    final Widget phoneAutheticationContent = BlocBuilder<UserAuthBloc, UserAuthState>(
      builder: (BuildContext context, UserAuthState state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextView(
              text: 'Please enter you phone number',
              color: Colors.black,
            ),
            ReactiveTextField<String>(
              formControlName: 'phoneNumber',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validationMessages: <String, String Function(Object)>{
                ValidationMessage.pattern:(Object error) => 'Please enter valid number',
              }
            ),
            ReactiveFormConsumer(
              builder: (BuildContext context, FormGroup formGroup, Widget? child){
                return OutlinedButton(
                  onPressed: formGroup.valid
                  ? () {
                    FocusScope.of(context).unfocus();
                    appState.userAuthenticationBloc.add(
                      FirebasePhoneAuthentication(userPhoneNumber: formGroup.value.values.first.toString())
                    );
                    context.go(AppRoutes.home.path+AppRoutes.signin.path+ '/' + AppRoutes.phoneAuthenticationForm.path+ '/' + AppRoutes.phoneVerificationForm.path);
                  }
                  : null,
                  child: const Text('Submit'),
                );
              },
            )
          ],
        );
      },
    );

    final ReactiveFormBuilder formBuilderForPhoneAuth = ReactiveFormBuilder(
      form: () => formGroupForPhoneAuth,
      builder: (BuildContext context, FormGroup formGroup, Widget? child) => phoneAutheticationContent,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: formBuilderForPhoneAuth
        ),
      ),
    );
  }

}
