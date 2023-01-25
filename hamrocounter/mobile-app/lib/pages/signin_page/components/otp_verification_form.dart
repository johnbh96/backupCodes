import 'package:flutter/material.dart';
import 'component.dart';

class OtpVerificationForm extends StatefulWidget {
  const OtpVerificationForm({
    Key? key,
  }) : super(key: key);

  @override
  State<OtpVerificationForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpVerificationForm> {
  @override
  Widget build(BuildContext context) {
    final AppState appState = AppState.of(context);
    final FormGroup otpFormGroup = FormGroup(<String, AbstractControl<dynamic>>{
      'otp': FormControl<String>(
        validators: <Map<String, dynamic>? Function(AbstractControl<dynamic>)>[
          Validators.required,
          Validators.pattern(RegularExpression.otpPattern),
          Validators.minLength(6),
          Validators.maxLength(6)
        ]
      ),
    });

    final ReactiveFormBuilder formBuilderForOTP = ReactiveFormBuilder(
      form: () => otpFormGroup,
      builder: (BuildContext context, FormGroup formGroup, Widget? child) {
        return BlocBuilder<UserAuthBloc, UserAuthState>(
          builder: (BuildContext context, UserAuthState state) {
            return StreamBuilder<dynamic>(
              stream: appState.smsStreamRepo.smsStream(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapShot) {
                if(snapShot.hasError){
                  return const SnackBar(
                    content: TextView(text: 'Something went wrong',)
                  );
                }

                final String? receivedOtp = appState.userAuthenticationBloc
                .getOtp(snapShot: snapShot);

                formGroup.controls.values.elementAt(0).value = receivedOtp;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const TextView(
                      text: 'Auto fill '
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ReactiveTextField<String>(
                        formControlName: 'otp',
                        keyboardType: TextInputType.number,
                        validationMessages: state is UnAuthenticated
                        ? <String, String Function(Object)> {
                          ValidationMessage.any:(Object error) => 'Invalid otp'
                        }
                        :null,
                      ),
                    ),
                    ReactiveFormConsumer(builder: (
                      BuildContext context, FormGroup buttonFromGroup, Widget? child){
                        return OutlinedButton(
                          onPressed: buttonFromGroup.valid
                          ? () {
                            FocusScope.of(context).unfocus();
                            appState.userAuthenticationBloc.add(
                              VerifyPhoneNumber(
                                otp: buttonFromGroup.value.values.first.toString(),
                              )
                            );
                          }
                          :null,
                          child: const Text('Verify phone number')
                        );
                      }
                    ),
                ],);
              }
            );
          },
        );
      },
    );

    return Scaffold(
      body: BlocListener<UserAuthBloc, UserAuthState>(
        listener: (BuildContext context, UserAuthState state) {
            if (state is Authenticated){
              showsnackBar(
                message: state.message,
                context: context
              );
              context.go(AppRoutes.home.path);
            }else if (state is UnAuthenticated){
              showsnackBar(
                message: state.message,
                context: context,
                color: Colors.black,
              );
            }
        },
        child: formBuilderForOTP,
      )
    );
  }
}
