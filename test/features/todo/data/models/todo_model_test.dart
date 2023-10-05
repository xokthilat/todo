import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo/features/todo/data/models/todo_model.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tTodoModel = TodoModel();

  tTodoModel
    ..id = "9dd9316f-39d2-4ef1-bfc6-45df0b847881"
    ..title = "Levitating - Dua Lipa ft. DaBaby"
    ..description =
        "I got you moonlight, you're my starlight / I need you all night, come on, dance with me / I'm levitating / You, moonlight, you're my starlight / I need you all night, come on, dance with me / I'm levitating"
    ..createdAt = DateTime.parse("2022-04-03T15:34:20.000Z")
    ..status = TodoStatus.DONE;

  test('should be a subclass of todo entity', () async {
    expect(tTodoModel, isA<Todo>());
  });
  test(
    'should return a valid model',
    () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('todo.json'));
      final result = TodoModel().fromJson(jsonMap);
      expect(result, tTodoModel);
    },
  );
}
