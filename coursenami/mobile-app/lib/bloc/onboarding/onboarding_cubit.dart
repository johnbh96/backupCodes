import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../go_router_helper/routes.dart';
import '../../utils/shared_prefs/shared_prefs.dart';

class OnBoardingCubit extends Cubit<bool> {
  final SharedPrefs _sharedPrefs;
  OnBoardingCubit({required SharedPrefs sharedPrefs}):
  _sharedPrefs = sharedPrefs, super(sharedPrefs.isWelcomeScreenShown);

  void skip(BuildContext context){
    _sharedPrefs.isWelcomeScreenShown = true;
    context.go(AppRoutes.home.path);
    emit(true);
  }
}
