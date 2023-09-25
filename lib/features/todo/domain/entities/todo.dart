// ignore becase its need to be uppercase to match with api response
// ignore_for_file: constant_identifier_names

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
