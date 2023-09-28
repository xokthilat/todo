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
  final authDetail = localDatabase.authDetail;
  if (authDetail == null) {
    return _getRoute(
        AppRoute.passcode,
        const PasscodePage(
          passcodePageParams: PasscodePageParams.set,
        ));
  }
  final isLock =
      isDateTimeMoreThanNSecondsAgo(authDetail.lastTouch, activeDurationInSec);

  if (isLock) {
    return _getRoute(
        AppRoute.passcode,
        const PasscodePage(
          passcodePageParams: PasscodePageParams.check,
        ));
  }

  switch (settings.name) {
    case AppRoute.home:
      return _getRoute(settings.name!, const Homepage());
    case AppRoute.passcode:
      return _getRoute(
          settings.name!,
          PasscodePage(
            passcodePageParams: settings.arguments as PasscodePageParams,
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
