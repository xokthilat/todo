part of 'homepage_bloc.dart';

class HomepageState {
  final List<Todo> todos;
  final PageStatus pageStatus;
  final bool isFinalPage;
  final int currentPage;

  HomepageState(
      {required this.todos,
      required this.pageStatus,
      this.isFinalPage = false,
      required this.currentPage});

  HomepageState copyWith({
    List<Todo>? todos,
    PageStatus? pageStatus,
    bool? isFinalPage,
  }) {
    return HomepageState(
      todos: todos ?? this.todos,
      pageStatus: pageStatus ?? this.pageStatus,
      isFinalPage: isFinalPage ?? this.isFinalPage,
      currentPage: currentPage,
    );
  }
}

enum PageStatus { todo, doing, done }

extension PageStatusExt on PageStatus {
  //convert status from ui to the server object
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
