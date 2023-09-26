import 'package:todo/core/interface/response/network_error.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/core/service/api_holder.dart';
import 'package:todo/core/service/local/objectbox_service.dart';
import 'package:todo/core/service/network_connectivity.dart';
import 'package:todo/features/todo/data/models/todo_model.dart';
import 'package:todo/features/todo/domain/entities/auth.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';
import 'package:todo/features/todo/domain/repositories/todo_repository.dart';

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
        var result = await networkExecuter.execute<TodoModel, List<Todo>>(
          route: ApiHolder.fetchTodoList(
              status: status,
              offset: offset,
              limit: limit,
              sortBy: sortBy,
              isAsc: isAsc),
          responseType: TodoModel(),
        );
        offset += limit;
        result.maybeWhen(
            orElse: () {},
            success: (data) {
              objectboxService.saveTodos(data);
            });
        return result;
      } else {
        return Result.success(objectboxService.todos);
      }
    } on TodoError catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(TodoError.type(error: e.toString()));
    }
  }

  @override
  Result<List<Todo>, TodoError> deleteTodoList(String id) {
    try {
      objectboxService.delteTodos(id);
      return Result.success(objectboxService.todos);
    } catch (e) {
      return Result.failure(TodoError.type(error: e.toString()));
    }
  }

  @override
  Result<Auth, TodoError> get getAuthDetail {
    try {
      return Result.success(objectboxService.getAuthDetail);
    } catch (e) {
      return Result.failure(TodoError.type(error: e.toString()));
    }
  }

  @override
  Result<int, TodoError> setLastOnline(DateTime time) {
    try {
      return Result.success(objectboxService.setLastOnline(time));
    } catch (e) {
      return Result.failure(TodoError.type(error: e.toString()));
    }
  }

  @override
  Result<int, TodoError> setLastTouch(DateTime time) {
    try {
      return Result.success(objectboxService.setLastTouch(time));
    } catch (e) {
      return Result.failure(TodoError.type(error: e.toString()));
    }
  }

  @override
  Result<int, TodoError> setPasscode(int passcode) {
    try {
      return Result.success(objectboxService.setPasscode(passcode));
    } catch (e) {
      return Result.failure(TodoError.type(error: e.toString()));
    }
  }

  @override
  Result<bool, TodoError> checkPasscode(int passcode) {
    try {
      return Result.success(objectboxService.checkPasscode(passcode));
    } catch (e) {
      return Result.failure(TodoError.type(error: e.toString()));
    }
  }
}
