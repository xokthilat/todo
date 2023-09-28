import 'package:todo/core/interface/response/result.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

import '../../../../core/interface/response/todo_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class GetTodoList implements UseCase<List<Todo>, TodoStatus> {
  final TodoRepository todoRepository;
  GetTodoList(this.todoRepository);
  @override
  Future<Result<List<Todo>, TodoError>> call(TodoStatus params) async {
    return todoRepository.getTodoList(params);
  }
}
