import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:todo/constants.dart';
import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/router/app_route.dart';
import 'package:todo/core/router/todo_navigator.dart';
import 'package:todo/core/style/todo_textstyle.dart';
import 'package:todo/service_locator.dart';

import '../../../../core/state/todo_state.dart';
import '../bloc/passcode/passcode_bloc.dart';
import '../bloc/passcode/passcode_event.dart';

enum PasscodePageParams { set, check, change }

class PasscodePage extends StatefulWidget {
  final PasscodePageParams passcodePageParams;
  const PasscodePage({super.key, required this.passcodePageParams});

  @override
  State<PasscodePage> createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<PasscodeBloc>(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            leading: sl<TodoNavigator>().navigatorKey.currentState!.canPop()
                ? Builder(builder: (ctx) {
                    return IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: highlightColor,
                      ),
                      onPressed: () {
                        BlocProvider.of<PasscodeBloc>(ctx)
                            .add(OnLastTouchSet());
                        sl<TodoNavigator>().popBack();
                      },
                    );
                  })
                : Container(),
          ),
          body: BlocProvider(
            create: (context) => sl<PasscodeBloc>(),
            child: BlocConsumer<PasscodeBloc, TodoState<bool>>(
              listener: (ctx, state) async {
                if (state is TodoErrorState) {
                  if (state is LocalRequestError) {
                    Fluttertoast.showToast(
                        msg: (state as LocalRequestError).errMsg!);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Something went wrong, please try again");
                  }
                } else if (state is TodoLoaded<bool>) {
                  if (state.data) {
                    sl<TodoNavigator>().navigateTo(AppRoute.home);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Wrong passcode, please try again");
                  }
                }
              },
              builder: (ctx, state) {
                return PasscodeScreen(
                  title: switch (widget.passcodePageParams) {
                    PasscodePageParams.change =>
                      "Change App Passcode".h2.highlightColor,
                    PasscodePageParams.set =>
                      "Set App Passcode".h2.highlightColor,
                    PasscodePageParams.check =>
                      'Enter App Passcode'.h2.highlightColor,
                  },
                  passwordEnteredCallback: (code) {
                    switch (widget.passcodePageParams) {
                      case PasscodePageParams.set:
                        BlocProvider.of<PasscodeBloc>(ctx)
                            .add(PasscodeSet(passcode: code));
                        return;
                      case PasscodePageParams.check:
                        BlocProvider.of<PasscodeBloc>(ctx)
                            .add(PasscodeCheck(passcode: code));
                      case PasscodePageParams.change:
                        BlocProvider.of<PasscodeBloc>(ctx)
                            .add(PasscodeChanged(passcode: code));
                    }
                  },
                  circleUIConfig: const CircleUIConfig(
                    borderColor: secondaryColor,
                    fillColor: highlightColor,
                    circleSize: 30,
                  ),
                  keyboardUIConfig: const KeyboardUIConfig(
                    primaryColor: secondaryColor,
                    digitFillColor: secondaryColor,
                    digitTextStyle: TextStyle(
                      color: highlightColor,
                      fontSize: 50,
                    ),
                  ),
                  deleteButton: 'Delete'.p.highlightColor,
                  shouldTriggerVerification: _verificationNotifier.stream,
                  backgroundColor: primaryColor,
                );
              },
            ),
          ),
        ));
  }
}
