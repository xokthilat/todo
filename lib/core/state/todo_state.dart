import '../interface/response/todo_error.dart';

sealed class TodoState<T> {
  const TodoState();
}

class TodoLoading<T> extends TodoState<T> {}

class TodoLoaded<T> extends TodoState<T> {
  final T data;
  const TodoLoaded(this.data);

  TodoLoaded<T> copyWith({
    T? data,
  }) {
    return TodoLoaded<T>(
      data ?? this.data,
    );
  }
}

class TodoErrorState<T> extends TodoState<T> {
  final TodoError error;
  const TodoErrorState(this.error);
}
