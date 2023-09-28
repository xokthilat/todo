import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/core/model/todo_response_model.dart';
import 'package:todo/core/service/api_holder.dart';
import 'package:todo/core/service/local/objectbox_service.dart';
import 'package:todo/core/service/network_connectivity.dart';
import 'package:todo/features/todo/domain/entities/auth.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';
import 'package:todo/features/todo/domain/repositories/todo_repository.dart';

import '../../../../core/entities/todo_response.dart';
import '../../../../core/single_source_of_truth/network_executer.dart';

class TodoRepositoryImpl implements TodoRepository {
  final NetworkExecuter networkExecuter;
  final ObjectboxService objectboxService;
  final NetworkConnectivity networkConnectivity;
  TodoRepositoryImpl({
    required this.networkExecuter,
    required this.objectboxService,
    required this.networkConnectivity,
  });
  int offset = 0;
  int limit = 10;
  String sortBy = "createdAt";
  bool isAsc = true;

  @override
  Future<Result<List<Todo>, TodoError>> getTodoList(TodoStatus status) async {
    try {
      if (await networkConnectivity.status) {
        var result =
            await networkExecuter.execute<TodoResponseModel, TodoResponse>(
          route: ApiHolder.fetchTodoList(
              status: status,
              offset: offset,
              limit: limit,
              sortBy: sortBy,
              isAsc: isAsc),
          responseType: TodoResponseModel(),
        );
        offset += limit;
        return result.when(success: (data) {
          objectboxService.saveTodos(data.tasks);
          return Result.success(objectboxService.todos
              .where((todo) => todo.status == status)
              .toList());
        }, failure: (TodoError error) {
          return Result.failure(error);
        });
      } else {
        return Result.success(objectboxService.todos);
      }
    } on TodoError catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(LocalRequestError(errMsg: e.toString()));
    }
  }

  @override
  Result<List<Todo>, TodoError> deleteTodoList(String id) {
    try {
      objectboxService.delteTodos(id);
      return Result.success(objectboxService.todos);
    } catch (e) {
      return Result.failure(LocalRequestError(errMsg: e.toString()));
    }
  }

  @override
  Result<Auth?, TodoError> get getAuthDetail {
    try {
      return Result.success(objectboxService.authDetail);
    } catch (e) {
      return Result.failure(LocalRequestError(errMsg: e.toString()));
    }
  }

  @override
  Result<int, TodoError> setLastOnline(DateTime time) {
    try {
      return Result.success(objectboxService.setLastOnline(time));
    } catch (e) {
      return Result.failure(LocalRequestError(errMsg: e.toString()));
    }
  }

  @override
  Result<int, TodoError> setLastTouch(DateTime time) {
    try {
      return Result.success(objectboxService.setLastTouch(time));
    } catch (e) {
      return Result.failure(LocalRequestError(errMsg: e.toString()));
    }
  }

  @override
  Result<int, TodoError> setPasscode(String passcode) {
    try {
      return Result.success(objectboxService.setPasscode(passcode));
    } catch (e) {
      return Result.failure(LocalRequestError(errMsg: e.toString()));
    }
  }

  @override
  Result<bool, TodoError> checkPasscode(String passcode) {
    try {
      return Result.success(objectboxService.checkPasscode(passcode));
    } catch (e) {
      return Result.failure(LocalRequestError(errMsg: e.toString()));
    }
  }
}
