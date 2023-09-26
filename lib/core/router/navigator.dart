import 'package:flutter/material.dart';

class Navigatior {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {var params}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: params);
  }

  Future<dynamic> navigateAndRemoveTo(String routeName, {var params}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: params);
  }

  Future<dynamic> navigateReplace(String routeName, {var params}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: params,
    );
  }

  navigateWithCallback(String routeName, {var params, dynamic onExcute}) async {
    final result = await navigatorKey.currentState!
        .pushNamed(routeName, arguments: params);

    if (result != null) {
      onExcute(result);
    }
  }

  void popBackWithData(dynamic data) {
    return navigatorKey.currentState!.pop(data);
  }

  void popBack() {
    return navigatorKey.currentState!.pop();
  }
}
