import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/core/entities/todo_response.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/features/todo/data/dao/todo_dao.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';
import 'package:todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo/features/todo/domain/usecases/get_todo_list.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late final MockTodoRepository mockTodoRepository;
  late final GetTodoList getTodoList;
  var fakeTodo = TodoDao(
      description: "description",
      title: "title",
      createdAt: DateTime.now(),
      id: "1");
  fakeTodo.dbStatus = 0;
  var fakeTodoRes =
      TodoResponse(pageNumber: 1, totalPages: 1, tasks: [fakeTodo]);

  const offset = 0;
  const limit = 10;
  const sortBy = "createdAt";
  const isAsc = false;
  const status = TodoStatus.TODO;
  setUpAll(() {
    mockTodoRepository = MockTodoRepository();
    getTodoList = GetTodoList(mockTodoRepository);
    registerFallbackValue(TodoStatus.TODO);
    registerFallbackValue(GetTodoListParam(
        status: status,
        fetchLocalOnly: false,
        limit: limit,
        sortBy: sortBy,
        isAsc: isAsc,
        offset: offset));
  });

  test('should get todo list success form repo', () async {
    //arrange
    when(() => mockTodoRepository.getTodoList(any()))
        .thenAnswer((_) async => Result.success(fakeTodoRes));
    //act
    final result = await getTodoList(GetTodoListParam(
        status: status,
        fetchLocalOnly: false,
        limit: limit,
        sortBy: sortBy,
        isAsc: isAsc,
        offset: offset));

    verify(() => mockTodoRepository.getTodoList(any()));

    result.when(success: (data) {
      expect(data, fakeTodoRes);
    }, failure: (error) {
      throw error;
    });

    verifyNoMoreInteractions(mockTodoRepository);
  });

  test('should get error when try to fetch todo form repo', () async {
    when(() => mockTodoRepository.getTodoList(any())).thenAnswer((_) async =>
        Result.failure(RequestError(
            error: DioException(requestOptions: RequestOptions()))));
    final result = await getTodoList(GetTodoListParam(
        status: status,
        fetchLocalOnly: false,
        limit: limit,
        sortBy: sortBy,
        isAsc: isAsc,
        offset: offset));

    verify(() => mockTodoRepository.getTodoList(any()));

    result.when(success: (data) {
      throw data;
    }, failure: (error) {
      expect(error, isA<TodoError>());
    });

    verifyNoMoreInteractions(mockTodoRepository);
  });
}
