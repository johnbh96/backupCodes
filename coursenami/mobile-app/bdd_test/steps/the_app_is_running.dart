import 'package:flutter_coursenami/pages/home_page/my_home_page.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> theAppIsRunning(WidgetTester tester) async {
  await tester.pumpWidget(const MyHomePage());
}
