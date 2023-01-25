import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
String package = 'gallery';
Widget get driverIcon {
  return SvgPicture.asset(
    'assets/svg/driver.svg', package: package,
  );
}