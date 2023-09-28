import 'package:todo/features/todo/domain/entities/todo.dart';

class HomepageState {
  final List<Todo> todos;
  final PageStatus pageStatus;

  HomepageState({required this.todos, required this.pageStatus});
}

enum PageStatus { todo, doing, done }

extension PageStatusExt on PageStatus {
  TodoStatus get todoStatus {
    switch (this) {
      case PageStatus.todo:
        return TodoStatus.TODO;
      case PageStatus.doing:
        return TodoStatus.DOING;
      case PageStatus.done:
        return TodoStatus.DOING;
    }
  }
}
