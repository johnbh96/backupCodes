import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'keys.dart';

class SharedPrefs {
  final SharedPreferences _prefs;
  final ValueNotifier<bool> welcomeScreenData;

  SharedPrefs({required SharedPreferences sharedPreferences})
      : welcomeScreenData = ValueNotifier<bool>(false),
        _prefs = sharedPreferences {
    welcomeScreenData.value = _prefs.getBool(welcomeScreenKey) ?? false;
    welcomeScreenData.addListener(() {
      _isWelcomeScreenShown = welcomeScreenData.value;
    });
  }

  // ignore: avoid_setters_without_getters
  set _isWelcomeScreenShown(bool showOnBoarding) {
    _prefs.setBool(welcomeScreenKey, showOnBoarding);
  }
}
