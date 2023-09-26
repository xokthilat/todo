import 'package:flutter/material.dart';
import 'package:todo/core/router/app_route.dart';
import 'package:todo/features/todo/presentation/pages/homepage.dart';
import 'package:todo/features/todo/presentation/pages/passcode_page.dart';

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoute.home:
      return _getRoute(settings.name!, const Homepage());
    case AppRoute.passcode:
      return _getRoute(settings.name!, const PasscodePage());
    default:
      return _getRoute(settings.name!, const PasscodePage());
  }
}

_getRoute(String routeName, Widget page) {
  return MaterialPageRoute(
    builder: (BuildContext context) => page,
    settings: RouteSettings(name: routeName),
  );
}
