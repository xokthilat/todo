import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/todo/domain/usecases/check_passcode.dart';
import 'package:todo/features/todo/domain/usecases/set_passcode.dart';
import 'package:todo/features/todo/presentation/bloc/passcode_event.dart';
import 'package:todo/features/todo/presentation/bloc/passcode_state.dart';

class PasscodeBloc extends Bloc<PasscodeEvent, PasscodeState> {
  final CheckPasscode checkPasscode;
  final SetPasscode setPasscode;
  PasscodeBloc({
    required this.checkPasscode,
    required this.setPasscode,
  }) : super(PasscodeState()) {
    on<PasscodeChanged>((event, emit) async {
      final res = await setPasscode(event.passcode);
      res.when(
          success: (id) {},
          failure: (e) {
            emit(PasscodeState(error: e));
          });
    });
    on<PasscodeCheck>((event, emit) async {
      final res = await checkPasscode(event.passcode);
      res.when(success: (isPass) {
        print(isPass);
      }, failure: (e) {
        emit(PasscodeState(error: e));
      });
    });
    on<PasscodeSet>((event, emit) async {
      final res = await setPasscode(event.passcode);
      res.when(success: (id) {
        print(id);
      }, failure: (e) {
        emit(PasscodeState(error: e));
      });
    });
  }
}
