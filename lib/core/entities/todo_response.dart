import 'package:equatable/equatable.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

class TodoResponse extends Equatable {
  final List<Todo> tasks;
  final int pageNumber;
  final int totalPages;

  const TodoResponse(
      {required this.tasks,
      required this.pageNumber,
      required this.totalPages});

  @override
  // TODO: implement props
  List<Object?> get props => [tasks, pageNumber, totalPages];
}
