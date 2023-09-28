import 'package:todo/features/todo/domain/entities/todo.dart';

class TodoResponse {
  late final List<Todo> tasks;
  late final int pageNumber;
  late final int totalPages;
}
