import 'package:todo/features/todo/domain/entities/todo.dart';

class HomepageState {
  final List<Todo> todos;
  final PageStatus pageStatus;

  // to avoid reading data from local storage while writing
  final bool? isWritingLastTouchData;
  final bool? isWritingLastOnlineData;

  HomepageState(
      {required this.todos,
      required this.pageStatus,
      this.isWritingLastOnlineData,
      this.isWritingLastTouchData});

  HomepageState copyWith({
    List<Todo>? todos,
    PageStatus? pageStatus,
    bool? isWritingLastOnlineData,
    bool? isWritingLastTouchData,
  }) {
    return HomepageState(
      todos: todos ?? this.todos,
      pageStatus: pageStatus ?? this.pageStatus,
      isWritingLastOnlineData:
          isWritingLastOnlineData ?? this.isWritingLastOnlineData,
      isWritingLastTouchData:
          isWritingLastTouchData ?? this.isWritingLastTouchData,
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
        return TodoStatus.DOING;
    }
  }
}
