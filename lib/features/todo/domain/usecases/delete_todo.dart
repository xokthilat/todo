import 'package:todo/core/interface/response/result.dart';

import '../../../../core/interface/response/todo_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class DeleteTodo implements UseCase<bool, String> {
  final TodoRepository todoRepository;
  DeleteTodo(this.todoRepository);
  @override
  Future<Result<bool, TodoError>> call(String params) {
    final res = todoRepository.deleteTodoList(params);
    return Future.value(res);
  }
}
