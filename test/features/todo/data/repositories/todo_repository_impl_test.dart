import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/core/entities/todo_response.dart';
import 'package:todo/core/interface/api_client/base_client_generator.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/model/todo_response_model.dart';
import 'package:todo/core/service/local/objectbox_service.dart';
import 'package:todo/core/service/network_connectivity.dart';
import 'package:todo/core/single_source_of_truth/network_executer.dart';
import 'package:todo/features/todo/data/dao/todo_dao.dart';
import 'package:todo/features/todo/data/models/todo_model.dart';
import 'package:todo/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';
import 'package:todo/features/todo/domain/usecases/get_todo_list.dart';

class MockNetworkExecuter extends Mock implements NetworkExecuter {}

class MockBaseClientGenerator extends Mock implements BaseClientGenerator {}

class MockObjectboxService extends Mock implements ObjectboxService {}

class MockNetworkConnectivity extends Mock implements NetworkConnectivity {}

class MockTodoModel extends Mock implements TodoModel {}

void main() {
  late final NetworkExecuter networkExecuter;
  late final TodoRepositoryImpl todoRepositoryImpl;
  late final ObjectboxService objectboxService;
  late final NetworkConnectivity networkConnectivity;
  setUpAll(() {
    networkExecuter = MockNetworkExecuter();
    objectboxService = MockObjectboxService();
    networkConnectivity = MockNetworkConnectivity();

    todoRepositoryImpl = TodoRepositoryImpl(
      networkExecuter: networkExecuter,
      objectboxService: objectboxService,
      networkConnectivity: networkConnectivity,
      onErrorToast: (p0, p1, p2) {},
    );
    registerFallbackValue(MockBaseClientGenerator());
    registerFallbackValue(TodoResponseModel());
    WidgetsFlutterBinding.ensureInitialized();
  });
  group("Todo Repository", () {
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
    test('Should return success when call getTodoList', () async {
      when(() => networkExecuter.execute<TodoResponseModel, TodoResponse>(
              route: any(named: "route"),
              responseType: any(named: "responseType")))
          .thenAnswer((_) async => Result.success(fakeTodoRes));
      when(() => objectboxService.todos).thenReturn([fakeTodo]);
      when(() => networkConnectivity.status).thenAnswer((_) async => true);
      when(() => objectboxService.deleteTodos()).thenReturn(null);
      when(() => objectboxService.saveTodos(fakeTodoRes.tasks))
          .thenReturn(null);

      var result = await todoRepositoryImpl.getTodoList(GetTodoListParam(
          status: status,
          fetchLocalOnly: false,
          limit: limit,
          sortBy: sortBy,
          isAsc: isAsc,
          offset: offset));

      result.when(success: (data) {
        expect(data, fakeTodoRes);
      }, failure: (e) {
        throw e;
      });
    });
    test('Should return success when call getTodoList with fetchLocalOnly',
        () async {
      when(() => objectboxService.todos).thenReturn([fakeTodo]);
      var result = await todoRepositoryImpl.getTodoList(GetTodoListParam(
          status: status,
          fetchLocalOnly: true,
          limit: limit,
          sortBy: sortBy,
          isAsc: isAsc,
          offset: offset));
      result.when(success: (data) {
        expect(data, fakeTodoRes);
      }, failure: (e) {
        throw e;
      });
    });
    test('Should return success when call but network got cut off', () async {
      when(() => networkConnectivity.status).thenAnswer((_) async => false);
      when(() => objectboxService.todos).thenReturn([fakeTodo]);
      var result = await todoRepositoryImpl.getTodoList(GetTodoListParam(
          status: status,
          fetchLocalOnly: false,
          limit: limit,
          sortBy: sortBy,
          isAsc: isAsc,
          offset: offset));
      result.when(success: (data) {
        expect(data, fakeTodoRes);
      }, failure: (e) {
        throw e;
      });
    });
    test('Should return request error failure when call getTodoList', () async {
      when(() => networkExecuter.execute<TodoResponseModel, TodoResponse>(
          route: any(named: "route"),
          responseType: any(
              named: "responseType"))).thenAnswer((_) async => Result.failure(
          RequestError(error: DioException(requestOptions: RequestOptions()))));
      when(() => networkConnectivity.status).thenAnswer((_) async => true);

      var result = await todoRepositoryImpl.getTodoList(GetTodoListParam(
          status: status,
          fetchLocalOnly: false,
          limit: limit,
          sortBy: sortBy,
          isAsc: isAsc,
          offset: offset));
      result.when(success: (data) {
        throw data;
      }, failure: (error) {
        expect(error, isA<RequestError>());
      });
    });
    test("Should return LocalRequestError when call getTodoList", () async {
      when(() => networkExecuter.execute<TodoResponseModel, TodoResponse>(
              route: any(named: "route"),
              responseType: any(named: "responseType")))
          .thenAnswer((_) async => Result.success(fakeTodoRes));
      when(() => networkConnectivity.status).thenAnswer((_) async => true);
      when(() => objectboxService.saveTodos(fakeTodoRes.tasks))
          .thenThrow(LocalRequestError(errMsg: ''));

      var result = await todoRepositoryImpl.getTodoList(GetTodoListParam(
          status: status,
          fetchLocalOnly: false,
          limit: limit,
          sortBy: sortBy,
          isAsc: isAsc,
          offset: offset));
      result.when(success: (data) {
        throw data;
      }, failure: (error) {
        expect(error, isA<LocalRequestError>());
      });
    });
  });
}
