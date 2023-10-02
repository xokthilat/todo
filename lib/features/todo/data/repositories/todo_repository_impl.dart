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
import '../../domain/usecases/get_todo_list.dart';

class TodoRepositoryImpl implements TodoRepository {
  final NetworkExecuter networkExecuter;
  final ObjectboxService objectboxService;
  final NetworkConnectivity networkConnectivity;
  TodoRepositoryImpl({
    required this.networkExecuter,
    required this.objectboxService,
    required this.networkConnectivity,
  });
  int offsetTodo = 0;
  int offsetDoing = 0;
  int offsetDone = 0;
  int limit = 10;
  String sortBy = "createdAt";
  bool isAsc = true;
  // bool isFinalPage = false;
  bool isFirstTime = true;

  @override
  Future<Result<GetTodoListRes, TodoError>> getTodoList(
      TodoStatus status) async {
    try {
      if (await networkConnectivity.status) {
        int offset = 0;
        switch (status) {
          case TodoStatus.TODO:
            offset = offsetTodo;
            break;
          case TodoStatus.DOING:
            offset = offsetDoing;
            break;
          case TodoStatus.DONE:
            offset = offsetDone;
            break;
          default:
            offset = offsetTodo;
        }
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

        return result.when(success: (data) {
          if (data.tasks.isNotEmpty) {
            switch (status) {
              case TodoStatus.TODO:
                offsetTodo++;
                break;
              case TodoStatus.DOING:
                offsetDoing++;
                break;
              case TodoStatus.DONE:
                offsetDone++;
                break;
              default:
                offsetTodo++;
            }
          }

          //clean all local data when first request for sync data between local and server
          if (isFirstTime) {
            objectboxService.deleteTodos();
            isFirstTime = false;
          }

          objectboxService.saveTodos(data.tasks);
          final todos = objectboxService.todos
              .where((todo) => todo.status == status)
              .toList();
          if (isAsc) {
            todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          }
          return Result.success(GetTodoListRes(
              isFinalPage: data.pageNumber == data.totalPages, todos: todos));
        }, failure: (TodoError error) {
          return Result.failure(error);
        });
      } else {
        return Result.success(
            GetTodoListRes(isFinalPage: true, todos: objectboxService.todos));
      }
    } on TodoError catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(LocalRequestError(errMsg: e.toString()));
    }
  }

  @override
  Result<bool, TodoError> deleteTodoList(String id) {
    try {
      return Result.success(objectboxService.deleteTodo(id));
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
