import 'package:todo/core/interface/response/result.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

import '../../../../core/entities/todo_response.dart';
import '../../../../core/interface/response/todo_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class GetTodoList implements UseCase<TodoResponse, GetTodoListParam> {
  final TodoRepository todoRepository;
  GetTodoList(this.todoRepository);
  @override
  Future<Result<TodoResponse, TodoError>> call(GetTodoListParam params) async {
    return todoRepository.getTodoList(params);
  }
}

// fetchLocalOnly is used to fetch data from local only in case of delete todo as it only happen in local, and for future function that only happen in local
class GetTodoListParam {
  final TodoStatus status;
  final bool fetchLocalOnly;
  final int limit;
  final String sortBy;
  final bool isAsc;
  final int offset;

  GetTodoListParam({
    required this.status,
    required this.fetchLocalOnly,
    required this.limit,
    required this.sortBy,
    required this.isAsc,
    required this.offset,
  });
}

// we declare a new class to return multiple data here becase it must only use by getTodoList usecase
// class GetTodoListRes {
//   final bool isFinalPage;
//   final List<Todo> todos;
//   final int? currentPage;
//   final int? totalPage;

//   GetTodoListRes({
//     required this.isFinalPage,
//     required this.todos,
//     this.currentPage,
//     this.totalPage,
//   });
// }
