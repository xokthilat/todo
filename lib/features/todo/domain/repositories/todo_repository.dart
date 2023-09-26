import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/features/todo/domain/entities/auth.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<Result<List<Todo>, TodoError>> getTodoList(TodoStatus status);
  Result<List<Todo>, TodoError> deleteTodoList(String id);
  Result<int, TodoError> setPasscode(int passcode);
  Result<int, TodoError> setLastOnline(DateTime time);
  Result<int, TodoError> setLastTouch(DateTime time);
  Result<Auth?, TodoError> get getAuthDetail;
  Result<bool, TodoError> checkPasscode(int passcode);
}
