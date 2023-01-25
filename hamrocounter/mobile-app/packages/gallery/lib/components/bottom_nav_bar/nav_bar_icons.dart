import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum NavButton { home, ticket, notification, profile }

extension NavButtonExtension on NavButton {
  Widget get getIcon {
    switch (this) {
      case NavButton.home:
        return SvgPicture.asset(
          'assets/svg/home.svg',
          width: 24,
          height: 24,
          package: 'gallery',
        );
      case NavButton.ticket:
        return SvgPicture.asset(
          'assets/svg/ticket.svg',
          width: 24,
          height: 24,
          package: 'gallery',
        );
      case NavButton.notification:
        return SvgPicture.asset(
          'assets/svg/notification.svg',
          width: 24,
          height: 24,
          package: 'gallery',
        );
      case NavButton.profile:
        return SvgPicture.asset(
          'assets/svg/profile.svg',
          width: 24,
          height: 24,
          package: 'gallery',
        );
    }
  }
}
