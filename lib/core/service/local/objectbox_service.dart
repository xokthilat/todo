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

    final todosDao = todos.map((e) {
      final todo = TodoDao(
        createdAt: e.createdAt,
        description: e.description,
        id: e.id,
        title: e.title,
      )..dbStatus = e.status.index;
      return todo;
    }).toList();
    todoBox.putMany(todosDao);
  }

  void deleteTodos() {
    final todoBox = _dataBase.box<TodoDao>();
    todoBox.removeAll();
  }

  DateTime? onlineTime;
  DateTime? touchTime;
  int setLastTouch(DateTime time) {
    touchTime = time;
    final todoBox = _dataBase.box<AuthDao>();
    final auth = todoBox.getAll().first;
    auth.lastTouch = time;
    final test = todoBox.put(auth);
    return test;
  }

  int setLastOnline(DateTime time) {
    onlineTime = time;
    final todoBox = _dataBase.box<AuthDao>();
    final auth = todoBox.getAll().first;

    auth.lastOnline = time;
    final test = todoBox.put(auth);
    return test;
  }

  int setPasscode(String passcode) {
    final todoBox = _dataBase.box<AuthDao>();
    if (authDetail == null) {
      final auth = AuthDao(
          lastTouch: DateTime.now(),
          lastOnline: DateTime.now(),
          passcode: passcode);
      return todoBox.put(auth);
    }
    final auth = todoBox.getAll().first;
    auth.passcode = passcode;
    return todoBox.put(auth);
  }

  AuthDao? get authDetail {
    final todoBox = _dataBase.box<AuthDao>();
    return todoBox.getAll().firstOrNull;
  }

  bool checkPasscode(String passcode) {
    final todoBox = _dataBase.box<AuthDao>();
    final auth = todoBox.getAll().first;
    return auth.passcode == passcode;
  }
}
