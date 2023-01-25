import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../utils/shared_prefs/shared_prefs.dart';

class OnBoardingCubit extends Cubit<bool> {
  final SharedPrefs _sharedPrefs;
  OnBoardingCubit({required SharedPrefs sharedPrefs})
      : _sharedPrefs = sharedPrefs,
        super(sharedPrefs.welcomeScreenData.value);

  void skip(BuildContext context) {
    _sharedPrefs.welcomeScreenData.value = true;
    emit(true);
  }
}
