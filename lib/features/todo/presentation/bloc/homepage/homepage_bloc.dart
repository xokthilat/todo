import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/router/app_route.dart';
import 'package:todo/core/router/todo_navigator.dart';

import 'package:todo/core/state/todo_state.dart';
import 'package:todo/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo/features/todo/domain/usecases/get_auth_detail.dart';
import 'package:todo/features/todo/domain/usecases/set_last_online.dart';
import 'package:todo/features/todo/domain/usecases/set_last_touch.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_event.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_state.dart';
import 'package:todo/features/todo/presentation/pages/passcode_page.dart';
import 'package:todo/service_locator.dart';

import '../../../../../constants.dart';
import '../../../../../core/router/router.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_todo_list.dart';

class HomepageBloc extends Bloc<HomepageEvent, TodoState<HomepageState>> {
  final GetTodoList getTodoList;
  final DeleteTodo deleteTodo;
  final SetLastOnline setLastOnline;
  final SetLastTouch setLastTouch;
  final GetAuthDetail getAuthDetail;
  HomepageBloc(
      {required this.getTodoList,
      required this.deleteTodo,
      required this.setLastOnline,
      required this.setLastTouch,
      required this.getAuthDetail})
      : super(TodoLoading<HomepageState>()) {
    on<FetchHomeData>((event, emit) async {
      final res = await getTodoList(event.pageStatus.todoStatus);
      res.when(success: (data) {
        emit(TodoLoaded<HomepageState>(
            HomepageState(todos: data, pageStatus: event.pageStatus)));
      }, failure: (e) {
        emit(TodoErrorState<HomepageState>(e));
      });
    });

    on<OnSubmitLastTouch>((event, emit) async {
      final res = await setLastTouch(DateTime.now());
      res.when(
          success: (data) {},
          failure: (e) {
            emit(TodoErrorState<HomepageState>(e));
          });
    });

    on<OnSubmitLastOnline>(_onSubmitLastOnline);

    on<OnStartInactiveValidation>(_onStartInactiveValidation);

    on<OnStopInactiveValidation>((event, emit) async {
      _timer?.cancel();
    });

    on<OnDeleteTodo>((event, emit) async {
      final res = await deleteTodo(event.id);
      res.when(success: (data) {
        emit(TodoLoaded<HomepageState>(
            (state as TodoLoaded<HomepageState>).data.copyWith(todos: data)));
      }, failure: (e) {
        emit(TodoErrorState<HomepageState>(e));
      });
    });

    on<OnPageChanged>((event, emit) {
      if (state is TodoLoaded<HomepageState>) {
        emit(TodoLoaded<HomepageState>((state as TodoLoaded<HomepageState>)
            .data
            .copyWith(pageStatus: event.pageStatus)));
      }
    });
  }
  Timer? _timer;

  FutureOr<void> _onSubmitLastOnline(
      OnSubmitLastOnline event, Emitter<TodoState<HomepageState>> emit) async {
    final res = await setLastOnline(DateTime.now());
    res.when(success: (data) async {
      if (state is TodoLoaded<HomepageState>) {}
    }, failure: (e) {
      emit(TodoErrorState<HomepageState>(e));
    });
  }

  FutureOr<void> _onStartInactiveValidation(OnStartInactiveValidation event,
      Emitter<TodoState<HomepageState>> emit) async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      print(timer.tick);
      final res = await setLastOnline(DateTime.now());
      res.when(success: (data) async {
        final res = await getAuthDetail(NoParams());
        res.when(success: (auth) {
          if (auth != null) {
            final isLock = isDateTimeMoreThanNSecondsAgo(
                auth.lastTouch, activeDurationInSec);
            if (isLock) {
              timer.cancel();
              sl<TodoNavigator>().navigateAndRemoveTo(AppRoute.passcode,
                  params: PasscodePageParams.check);
            }
          }
        }, failure: (e) {
          emit(TodoErrorState<HomepageState>(e));
        });
      }, failure: (e) {
        emit(TodoErrorState<HomepageState>(e));
      });
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
