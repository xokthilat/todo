import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/core/entities/todo_response.dart';
import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/model/todo_response_model.dart';
import 'package:todo/core/service/api_holder.dart';
import 'package:todo/core/service/network_connectivity.dart';
import 'package:todo/core/service/network_creator.dart';
import 'package:todo/core/single_source_of_truth/network_decoder.dart';
import 'package:todo/core/single_source_of_truth/network_executer.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

import '../../fixtures/fixture_reader.dart';

class MockNetworkConnectivity extends Mock implements NetworkConnectivity {}

void main() {
  late final NetworkConnectivity networkConnectivity;
  late final NetworkCreator networkCreator;
  late final NetworkDecoder networkDecoder;
  late final NetworkExecuter networkExecuter;
  late final Dio cilent;
  setUpAll(() {
    networkConnectivity = MockNetworkConnectivity();
    cilent = Dio(BaseOptions());
    networkCreator = NetworkCreator(client: cilent);
    networkDecoder = NetworkDecoder();
    networkExecuter = NetworkExecuter(
        debugMode: true,
        networkDecoder: networkDecoder,
        networkCreator: networkCreator,
        networkConnectivity: networkConnectivity);
  });
  group("Network executer", () {
    const offset = 0;
    const limit = 10;
    const sortBy = "createdAt";
    const isAsc = false;
    const status = TodoStatus.TODO;
    test('should return serialized list of coin success when execute api call',
        () async {
      final dioAdapter = DioAdapter(dio: cilent);
      dioAdapter.onGet(
        const ApiHolder.fetchTodoList(
                offset: offset,
                limit: limit,
                sortBy: sortBy,
                isAsc: isAsc,
                status: status)
            .path,
        (server) => server.reply(200, json.decode(fixture('todos.json'))),
      );
      when(() => networkConnectivity.status).thenAnswer((_) async {
        return true;
      });
      final jsonDecoded = json.decode(fixture('todos.json'));
      final expectedResult = TodoResponseModel().fromJson(jsonDecoded);
      var result =
          await networkExecuter.execute<TodoResponseModel, TodoResponse>(
              route: const ApiHolder.fetchTodoList(
                  offset: offset,
                  limit: limit,
                  sortBy: sortBy,
                  isAsc: isAsc,
                  status: status),
              responseType: TodoResponseModel());
      result.when(failure: (e) {
        throw e;
      }, success: (data) {
        expect(data, expectedResult);
      });
    });
    test('should return network error when execute api call', () async {
      final dioAdapter = DioAdapter(dio: cilent);
      dioAdapter.onGet(
        const ApiHolder.fetchTodoList(
                offset: offset,
                limit: limit,
                sortBy: sortBy,
                isAsc: isAsc,
                status: status)
            .path,
        (server) => server.reply(400, json.decode(fixture('todos.json'))),
      );
      when(() => networkConnectivity.status).thenAnswer((_) async {
        return true;
      });
      var result =
          await networkExecuter.execute<TodoResponseModel, TodoResponse>(
              route: const ApiHolder.fetchTodoList(
                  offset: offset,
                  limit: limit,
                  sortBy: sortBy,
                  isAsc: isAsc,
                  status: status),
              responseType: TodoResponseModel());
      result.when(failure: (error) {
        expect(error, isA<RequestError>());
      }, success: (data) {
        throw data;
      });
    });
    test('should return type error when execute api call', () async {
      final dioAdapter = DioAdapter(dio: cilent);
      dioAdapter.onGet(
        const ApiHolder.fetchTodoList(
                offset: offset,
                limit: limit,
                sortBy: sortBy,
                isAsc: isAsc,
                status: status)
            .path,
        (server) => server.reply(200, json.decode(fixture('todo.json'))),
      );
      when(() => networkConnectivity.status).thenAnswer((_) async {
        return true;
      });
      var result =
          await networkExecuter.execute<TodoResponseModel, TodoResponse>(
              route: const ApiHolder.fetchTodoList(
                  offset: offset,
                  limit: limit,
                  sortBy: sortBy,
                  isAsc: isAsc,
                  status: status),
              responseType: TodoResponseModel());
      result.when(failure: (error) {
        expect(error, isA<DecodingError>());
      }, success: (data) {
        throw data;
      });
    });
    test('should return no internet connection when execute api call',
        () async {
      final dioAdapter = DioAdapter(dio: cilent);
      dioAdapter.onGet(
        const ApiHolder.fetchTodoList(
                offset: offset,
                limit: limit,
                sortBy: sortBy,
                isAsc: isAsc,
                status: status)
            .path,
        (server) => server.reply(200, json.decode(fixture('todos.json'))),
      );
      when(() => networkConnectivity.status).thenAnswer((_) async {
        return false;
      });
      var result =
          await networkExecuter.execute<TodoResponseModel, TodoResponse>(
              route: const ApiHolder.fetchTodoList(
                  offset: offset,
                  limit: limit,
                  sortBy: sortBy,
                  isAsc: isAsc,
                  status: status),
              responseType: TodoResponseModel());
      result.when(failure: (error) {
        expect(error, isA<ConnectivityError>());
      }, success: (data) {
        throw data;
      });
    });
  });
}
