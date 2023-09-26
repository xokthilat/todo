import 'package:todo/core/interface/response/result.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

import '../../../../core/interface/response/todo_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class DeleteTodo implements UseCase<List<Todo>, String> {
  final TodoRepository todoRepository;
  DeleteTodo(this.todoRepository);
  @override
  Future<Result<List<Todo>, TodoError>> call(String params) async {
    return todoRepository.deleteTodoList(params);
  }
}
