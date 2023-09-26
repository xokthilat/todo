class PasscodeEvent {}

class PasscodeChanged extends PasscodeEvent {
  final String passcode;

  PasscodeChanged({required this.passcode});
}

class PasscodeCheck extends PasscodeEvent {
  final String passcode;

  PasscodeCheck({required this.passcode});
}

class PasscodeSet extends PasscodeEvent {
  final String passcode;

  PasscodeSet({required this.passcode});
}
