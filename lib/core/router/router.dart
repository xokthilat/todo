import 'package:flutter/material.dart';
import 'package:todo/constants.dart';
import 'package:todo/core/router/app_route.dart';
import 'package:todo/core/service/local/objectbox_service.dart';
import 'package:todo/features/todo/presentation/pages/homepage.dart';
import 'package:todo/features/todo/presentation/pages/passcode_page.dart';

import '../../service_locator.dart';

bool isDateTimeMoreThanNSecondsAgo(DateTime dateTime, int n) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);
  return difference.inSeconds > n;
}

Route generateRoute(RouteSettings settings) {
  final localDatabase = sl<ObjectboxService>();
  return _getRoute(settings.name!, const Homepage());
  final authDetail = localDatabase.authDetail;
  if (authDetail == null) {
    return _getRoute(
        AppRoute.passcode,
        const PasscodePage(
          isSetPasscode: true,
        ));
  }
  final isLock = isDateTimeMoreThanNSecondsAgo(
          authDetail.lastOnline, activeDurationInSec) ||
      isDateTimeMoreThanNSecondsAgo(authDetail.lastTouch, activeDurationInSec);
  if (isLock) {
    return _getRoute(
        AppRoute.passcode,
        const PasscodePage(
          isSetPasscode: false,
        ));
  }

  switch (settings.name) {
    case AppRoute.home:
      return _getRoute(settings.name!, const Homepage());
    case AppRoute.passcode:
      return _getRoute(
          settings.name!,
          PasscodePage(
            isSetPasscode: settings.arguments as bool,
          ));
    default:
      return _getRoute(settings.name!, const Homepage());
  }
}

_getRoute(String routeName, Widget page) {
  return MaterialPageRoute(
    builder: (BuildContext context) => page,
    settings: RouteSettings(name: routeName),
  );
}
