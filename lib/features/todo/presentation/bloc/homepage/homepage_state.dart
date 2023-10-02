import 'package:todo/features/todo/domain/entities/todo.dart';

class HomepageState {
  final List<Todo> todos;
  final PageStatus pageStatus;
  final bool isFinalPage;

  // to avoid reading data from local storage while writing

  HomepageState(
      {required this.todos,
      required this.pageStatus,
      this.isFinalPage = false});

  HomepageState copyWith({
    List<Todo>? todos,
    PageStatus? pageStatus,
    bool? isFinalPage,
  }) {
    return HomepageState(
      todos: todos ?? this.todos,
      pageStatus: pageStatus ?? this.pageStatus,
      isFinalPage: isFinalPage ?? this.isFinalPage,
    );
  }
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
        return TodoStatus.DONE;
    }
  }
}
