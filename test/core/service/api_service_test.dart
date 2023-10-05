import 'package:flutter_test/flutter_test.dart';
import 'package:todo/api_config.dart';
import 'package:todo/core/service/api_holder.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

void main() {
  group("fetch list of coin holder", () {
    const offset = 0;
    const limit = 10;
    const sortBy = "createdAt";
    const isAsc = false;
    const status = TodoStatus.TODO;
    const apiHolder = ApiHolder.fetchTodoList(
        isAsc: isAsc,
        limit: limit,
        offset: offset,
        sortBy: sortBy,
        status: status);

    test("should return base url", () {
      expect(apiHolder.baseURL, baseUrl);
    });
    test("should return application/json in header", () {
      var expectedHeader = {"Content-Type": "application/json"};
      expect(apiHolder.header, expectedHeader);
    });
    test("should return application/json in header", () {
      var expectedHeader = {"Content-Type": "application/json"};
      expect(apiHolder.header, expectedHeader);
    });
    test("should return correct path", () {
      var expectedPath = "todo-list";
      expect(apiHolder.path, expectedPath);
    });
    test("should return correct http method", () {
      var expectedHttpMethod = "GET";
      expect(apiHolder.method, expectedHttpMethod);
    });
    test("should return null body", () {
      expect(apiHolder.body, null);
    });
    test("should return correct query parameters", () {
      var expectedqueryParameter = {
        "offset": offset,
        "limit": limit,
        "sortBy": sortBy,
        "isAsc": isAsc,
        "status": status.name,
      };
      expect(apiHolder.queryParameters, expectedqueryParameter);
    });
  });
}
