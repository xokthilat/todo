import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:todo/core/service/api_holder.dart';
import 'package:todo/core/service/network_creator.dart';
import 'package:todo/core/service/network_options/network_options.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  late final NetworkCreator networkCreator;
  late final Dio cilent;
  setUpAll(() {
    cilent = Dio(BaseOptions());
    networkCreator = NetworkCreator(client: cilent);
  });
  group("network creator", () {
    const offset = 0;
    const limit = 10;
    const sortBy = "createdAt";
    const isAsc = false;
    const status = TodoStatus.TODO;
    test('should return success request', () async {
      final dioAdapter = DioAdapter(dio: cilent);
      dioAdapter.onGet(
        const ApiHolder.fetchTodoList(
                offset: offset,
                limit: limit,
                sortBy: sortBy,
                isAsc: isAsc,
                status: status)
            .path,
        (server) => server.reply(200, fixture('todos.json')),
      );
      NetworkOptions networkOptions =
          NetworkOptions(onReceiveProgress: (int count, int total) => {});
      var response = await networkCreator.request(
          route: const ApiHolder.fetchTodoList(
              offset: offset,
              limit: limit,
              sortBy: sortBy,
              isAsc: isAsc,
              status: status),
          options: networkOptions);
      expect(response.statusCode, 200);
      expect(response.data, fixture('todos.json'));
    });
  });
}
