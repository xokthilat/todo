import 'package:todo/core/interface/response/result.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

import '../../../../core/interface/response/todo_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class GetTodoList implements UseCase<GetTodoListRes, TodoStatus> {
  final TodoRepository todoRepository;
  GetTodoList(this.todoRepository);
  @override
  Future<Result<GetTodoListRes, TodoError>> call(TodoStatus params) async {
    return todoRepository.getTodoList(params);
  }
}

// we declare a new class to return multiple data here becase it must only use by getTodoList usecase
class GetTodoListRes {
  final bool isFinalPage;
  final List<Todo> todos;

  GetTodoListRes({required this.isFinalPage, required this.todos});
}
