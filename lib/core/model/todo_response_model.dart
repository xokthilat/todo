import 'package:todo/core/entities/todo_response.dart';

import '../../features/todo/data/models/todo_model.dart';
import '../../features/todo/domain/entities/todo.dart';
import '../interface/models/base_network_model.dart';

class TodoResponseModel extends BaseNetworkModel<TodoResponseModel>
    implements TodoResponse {
  @override
  late final int pageNumber;

  @override
  late final List<Todo> tasks;

  @override
  late final int totalPages;

  @override
  TodoResponseModel fromJson(Map<String, dynamic> json) {
    return TodoResponseModel()
      ..pageNumber = json['pageNumber'] as int
      ..tasks = (json['tasks'] as List<dynamic>)
          .map((e) => TodoModel().fromJson(e as Map<String, dynamic>))
          .toList()
      ..totalPages = json['totalPages'] as int;
  }
}
