import 'package:todo/core/entities/todo_response.dart';

class TodoResponseModel<T> implements TodoResponse<T> {
  TodoResponseModel<T> fromJson(
    Map<String, dynamic> json,
    T Function(List<dynamic> json) fromJsonT,
  ) {
    return TodoResponseModel<T>()
      ..tasks = fromJsonT(json["tasks"])
      ..pageNumber = json["pageNumber"]
      ..totalPages = json["totalPages"];
  }

  @override
  late final int pageNumber;

  @override
  late final T tasks;

  @override
  late final int totalPages;
}
