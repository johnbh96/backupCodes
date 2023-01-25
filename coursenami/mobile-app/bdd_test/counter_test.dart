// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './../bdd_test/steps/the_app_is_running.dart';
import './../bdd_test/steps/i_see_text.dart';
import './../bdd_test/steps/i_see_icon.dart';
import './../bdd_test/steps/i_tap_icon.dart';

void main() {
  group('''Counter App Running''', () {
    testWidgets(
        '''Initially the counter value is not greater than 0 when the app starts for the first time''',
        (WidgetTester tester) async {
      await theAppIsRunning(tester);
      await iSeeText(tester, '0');
      await iSeeIcon(tester, Icons.arrow_forward);
      await iSeeIcon(tester, Icons.arrow_back);
    });
    testWidgets('''Arrow Forward button increases the counter value''',
        (WidgetTester tester) async {
      await theAppIsRunning(tester);
      await iTapIcon(tester, Icons.arrow_forward);
      await iSeeText(tester, '1');
    });
  });
}
