import 'package:todo/core/interface/response/network_error.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/features/todo/domain/entities/auth.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<Result<List<Todo>, NetworkError>> getTodoList(TodoStatus status);
  Result<List<Todo>, NetworkError> deleteTodoList(String id);
  Result<int, NetworkError> setPasscode(int passcode);
  Result<int, NetworkError> setLastOnline(DateTime time);
  Result<int, NetworkError> setLastTouch(DateTime time);
  Result<Auth, NetworkError> get getAuthDetail;
  Result<bool, NetworkError> checkPasscode(int passcode);
}
