import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/features/todo/domain/entities/auth.dart';

import '../../../../core/entities/todo_response.dart';
import '../usecases/get_todo_list.dart';

abstract class TodoRepository {
  Future<Result<TodoResponse, TodoError>> getTodoList(GetTodoListParam param);
  Result<bool, TodoError> deleteTodoList(String id);
  Result<int, TodoError> setPasscode(String passcode);
  Result<int, TodoError> setLastOnline(DateTime time);
  Result<int, TodoError> setLastTouch(DateTime time);
  Result<Auth?, TodoError> get getAuthDetail;
  Result<bool, TodoError> checkPasscode(String passcode);
}
