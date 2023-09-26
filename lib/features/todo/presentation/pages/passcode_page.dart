import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:todo/constants.dart';
import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/style/todo_textstyle.dart';
import 'package:todo/features/todo/presentation/bloc/passcode_bloc.dart';
import 'package:todo/service_locator.dart';

import '../bloc/passcode_event.dart';
import '../bloc/passcode_state.dart';

class PasscodePage extends StatefulWidget {
  final bool isSetPasscode;
  const PasscodePage({super.key, required this.isSetPasscode});

  @override
  State<PasscodePage> createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => sl<PasscodeBloc>(),
        child: BlocConsumer<PasscodeBloc, PasscodeState>(
          listener: (ctx, state) {
            if (state.error != null) {
              if (state.error is LocalRequestError) {
                Fluttertoast.showToast(
                    msg: (state.error as LocalRequestError).error!);
              } else {
                Fluttertoast.showToast(
                    msg: "Something went wrong, please try again");
              }
            }
          },
          builder: (ctx, state) {
            return PasscodeScreen(
              title: widget.isSetPasscode
                  ? "Set App Passcode".h2.highlightColor
                  : 'Enter App Passcode'.h2.highlightColor,
              passwordEnteredCallback: (code) {
                if (widget.isSetPasscode) {
                  BlocProvider.of<PasscodeBloc>(ctx)
                      .add(PasscodeSet(passcode: code));
                } else {
                  BlocProvider.of<PasscodeBloc>(ctx)
                      .add(PasscodeCheck(passcode: code));
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
    );
  }
}
