import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo/core/state/todo_state.dart';
import 'package:todo/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo/features/todo/domain/usecases/set_last_online.dart';
import 'package:todo/features/todo/domain/usecases/set_last_touch.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_event.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_state.dart';

import '../../../domain/usecases/get_todo_list.dart';

class HomepageBloc extends Bloc<HomepageEvent, TodoState<HomepageState>> {
  final GetTodoList getTodoList;
  final DeleteTodo deleteTodo;
  final SetLastOnline setLastOnline;
  final SetLastTouch setLastTouch;
  HomepageBloc({
    required this.getTodoList,
    required this.deleteTodo,
    required this.setLastOnline,
    required this.setLastTouch,
  }) : super(TodoLoading<HomepageState>()) {
    on<FetchHomeData>((event, emit) async {
      final res = await getTodoList(event.pageStatus.todoStatus);
      res.when(success: (data) {
        emit(TodoLoaded<HomepageState>(
            HomepageState(todos: data, pageStatus: event.pageStatus)));
      }, failure: (e) {
        emit(TodoErrorState<HomepageState>(e));
      });
    });

    on<OnSubmitLastTouch>((event, emit) => null);

    on<OnSubmitLastOnline>((event, emit) => null);

    on<OnDeleteTodo>((event, emit) => null);

    on<OnPageChanged>((event, emit) => null);
  }
}
