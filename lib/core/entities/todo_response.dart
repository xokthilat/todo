import 'package:todo/features/todo/domain/entities/todo.dart';

class TodoResponse {
  final List<Todo> tasks;
  final int pageNumber;
  final int totalPages;

  TodoResponse(
      {required this.tasks,
      required this.pageNumber,
      required this.totalPages});
}
