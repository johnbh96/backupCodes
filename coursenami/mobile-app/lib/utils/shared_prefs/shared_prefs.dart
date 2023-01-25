import 'package:shared_preferences/shared_preferences.dart';

import 'keys.dart';

class SharedPrefs {
  final SharedPreferences _prefs;

  SharedPrefs({required SharedPreferences sharedPreferences}):
    _prefs = sharedPreferences;


  bool get isWelcomeScreenShown {
    return _prefs.getBool(welcomeScreenKey) ?? false;
  }

  set isWelcomeScreenShown(bool showOnBoarding){
    _prefs.setBool(welcomeScreenKey, showOnBoarding);
  }
}
