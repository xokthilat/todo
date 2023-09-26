import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';

class PasscodePage extends StatefulWidget {
  const PasscodePage({super.key});

  @override
  State<PasscodePage> createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasscodeScreen(
        title: Text('Enter App Passcode'),
        passwordEnteredCallback: (code) {},
        deleteButton: Text('Delete'),
        shouldTriggerVerification: _verificationNotifier.stream,
      ),
    );
  }
}
