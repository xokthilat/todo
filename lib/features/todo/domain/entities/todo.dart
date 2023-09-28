// ignore becase its need to be uppercase to match with api response
// ignore_for_file: constant_identifier_names
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

enum TodoStatus { TODO, DOING, DONE, UNKNOWN }

class Todo {
  late final String id;
  late final String title;
  late final String description;
  late final DateTime createdAt;
  late final TodoStatus status;

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, description: $description, createdAt: $createdAt, status: $status)';
  }
}

extension TodoExt on List<Todo> {
  Map<String, List<Todo>> get groupByDate {
    // return groupBy<Todo, DateTime>(this, (e) => e.createdAt.);
    var groupByDate =
        groupBy(this, (obj) => obj.createdAt.toString().substring(0, 10));
    return groupByDate;
  }
}
