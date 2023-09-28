import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/state/todo_state.dart';
import 'package:todo/features/todo/domain/usecases/check_passcode.dart';
import 'package:todo/features/todo/domain/usecases/set_last_online.dart';
import 'package:todo/features/todo/domain/usecases/set_passcode.dart';
import 'package:todo/features/todo/presentation/bloc/passcode/passcode_event.dart';

import '../../../domain/usecases/set_last_touch.dart';

class PasscodeBloc extends Bloc<PasscodeEvent, TodoState<bool>> {
  final CheckPasscode checkPasscode;
  final SetPasscode setPasscode;
  final SetLastOnline setLastOnline;
  final SetLastTouch setLastTouch;
  PasscodeBloc({
    required this.checkPasscode,
    required this.setPasscode,
    required this.setLastOnline,
    required this.setLastTouch,
  }) : super(TodoLoading()) {
    on<PasscodeChanged>((event, emit) async {
      final res = await setPasscode(event.passcode);
      res.when(success: (id) {
        emit(const TodoLoaded(true));
      }, failure: (e) {
        emit(TodoErrorState(e));
      });
    });
    on<PasscodeCheck>((event, emit) async {
      setLastOnline(DateTime.now());
      setLastTouch(DateTime.now());

      final res = await checkPasscode(event.passcode);
      res.when(success: (isPass) {
        emit(const TodoLoaded(true));
      }, failure: (e) {
        emit(TodoErrorState(e));
      });
    });
    on<PasscodeSet>((event, emit) async {
      final res = await setPasscode(event.passcode);
      res.when(success: (id) {
        emit(const TodoLoaded(true));
      }, failure: (e) {
        emit(TodoErrorState(e));
      });
    });

    on<OnLastTouchSet>((event, emit) async {
      final res = await setLastTouch(DateTime.now());
      res.when(
          success: (data) {},
          failure: (e) {
            emit(TodoErrorState(e));
          });
    });
  }
}
