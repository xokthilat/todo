import 'package:flutter/foundation.dart';
import 'package:todo/features/todo/data/dao/auth_dao.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';
import 'package:todo/objectbox.g.dart';

import '../../../features/todo/data/dao/todo_dao.dart';

class ObjectboxService {
  final String dir;
  static Store? _store;

  ObjectboxService(this.dir);
  Store get _dataBase {
    if (_store != null) {
      return _store!;
    }

    initDB();
    if (kDebugMode) {
      print(todos);
      print(authDetail);
    }
    return _store!;
  }

  Future<void> initDB() async {
    _store = Store(getObjectBoxModel(), directory: '$dir/objectbox');
  }

  List<TodoDao> get todos {
    final todoBox = _dataBase.box<TodoDao>();
    return todoBox.getAll();
  }

  void delteTodos(String id) {
    final todoBox = _dataBase.box<TodoDao>();
    final selectedTodo = todos.where((todo) => id == todo.id).first;
    todoBox.remove(selectedTodo.localId);
  }

  void saveTodos(List<Todo> todos) {
    final todoBox = _dataBase.box<TodoDao>();

    final todosDao = todos
        .map((e) => TodoDao(
              createdAt: e.createdAt,
              description: e.description,
              id: e.id,
              title: e.title,
            ))
        .toList();
    todoBox.putMany(todosDao);
  }

  void deleteTodos() {
    final todoBox = _dataBase.box<TodoDao>();
    todoBox.removeAll();
  }

  int setLastTouch(DateTime time) {
    final todoBox = _dataBase.box<AuthDao>();
    final auth = todoBox.getAll().first;
    auth.lastTouch = time;
    return todoBox.put(auth);
  }

  int setLastOnline(DateTime time) {
    final todoBox = _dataBase.box<AuthDao>();
    final auth = todoBox.getAll().first;
    auth.lastOnline = time;
    return todoBox.put(auth);
  }

  int setPasscode(int passcode) {
    final todoBox = _dataBase.box<AuthDao>();
    final auth = todoBox.getAll().first;
    auth.passcode = passcode;
    return todoBox.put(auth);
  }

  AuthDao? get authDetail {
    final todoBox = _dataBase.box<AuthDao>();
    return todoBox.getAll().firstOrNull;
  }

  bool checkPasscode(int passcode) {
    final todoBox = _dataBase.box<AuthDao>();
    final auth = todoBox.getAll().first;
    return auth.passcode == passcode;
  }
}
