import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/api_config.dart';
import 'package:todo/core/router/app_route.dart';
import 'package:todo/core/router/todo_navigator.dart';

import 'package:todo/core/state/todo_state.dart';
import 'package:todo/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo/features/todo/domain/usecases/get_auth_detail.dart';
import 'package:todo/features/todo/domain/usecases/set_last_online.dart';
import 'package:todo/features/todo/domain/usecases/set_last_touch.dart';
import 'package:todo/features/todo/presentation/pages/passcode_page.dart';
import 'package:todo/service_locator.dart';

import '../../../../../constants.dart';
import '../../../../../core/router/router.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/todo.dart';
import '../../../domain/usecases/get_todo_list.dart';
part 'homepage_state.dart';
part 'homepage_event.dart';

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
    // we use this variable to prevent multiple request to server when ui reach buttom and try to fetch more data
    bool isLock = false;

    on<FetchHomeData>((event, emit) async {
      emit(TodoLoading());
      final res = await getTodoList(GetTodoListParam(
          status: event.pageStatus.todoStatus,
          fetchLocalOnly: event.fetchLocalOnly,
          limit: apiLimit,
          isAsc: isAsc,
          sortBy: sortBy,
          offset: 0));
      res.when(success: (data) {
        // if task is more than apiLimit * data.totalPages - 1 also mean we reach the last page

        emit(TodoLoaded<HomepageState>(HomepageState(
          todos: data.tasks,
          pageStatus: event.pageStatus,
          isFinalPage: (data.totalPages == data.pageNumber) ||
              (data.tasks.length > apiLimit * data.totalPages - 1),
          currentPage: data.pageNumber,
        )));
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
        isLock = false;
        add(
          FetchHomeData(
              pageStatus: (state as TodoLoaded<HomepageState>).data.pageStatus,
              fetchLocalOnly: true),
        );
      }, failure: (e) {
        emit(TodoErrorState<HomepageState>(e));
      });
    });

    on<OnPageChanged>((event, emit) {
      isLock = false;
      emit(TodoLoading());

      //TODO : might need to save current page to state to avoid start fetch from offset 0 when switch page. for now it seems a bit over engineering
      add(FetchHomeData(pageStatus: event.pageStatus));
    });

    on<OnFetchMore>((event, emit) async {
      if (isLock) return;
      isLock = true;
      if (state is TodoLoaded<HomepageState>) {
        final data = (state as TodoLoaded<HomepageState>).data;
        if (!data.isFinalPage) {
          final res = await getTodoList(GetTodoListParam(
              status: event.pageStatus.todoStatus,
              fetchLocalOnly: false,
              limit: apiLimit,
              isAsc: isAsc,
              sortBy: sortBy,
              offset: data.currentPage + 1));
          res.when(success: (data) {
            emit(TodoLoaded<HomepageState>(HomepageState(
                todos: data.tasks,
                pageStatus: event.pageStatus,
                isFinalPage: data.pageNumber == data.totalPages,
                currentPage: data.pageNumber)));
            isLock = false;
          }, failure: (e) {
            emit(TodoErrorState<HomepageState>(e));
          });
        }
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
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
