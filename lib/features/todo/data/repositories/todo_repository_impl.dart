import 'package:flutter/material.dart';
import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/core/model/todo_response_model.dart';
import 'package:todo/core/service/api_holder.dart';
import 'package:todo/core/service/local/objectbox_service.dart';
import 'package:todo/core/service/network_connectivity.dart';
import 'package:todo/features/todo/domain/entities/auth.dart';
import 'package:todo/features/todo/domain/repositories/todo_repository.dart';

import '../../../../core/entities/todo_response.dart';
import '../../../../core/single_source_of_truth/network_executer.dart';
import '../../domain/usecases/get_todo_list.dart';

class TodoRepositoryImpl implements TodoRepository {
  final NetworkExecuter networkExecuter;
  final ObjectboxService objectboxService;
  final NetworkConnectivity networkConnectivity;
  final Function(String, Color, Color) onErrorToast;
  TodoRepositoryImpl({
    required this.networkExecuter,
    required this.objectboxService,
    required this.networkConnectivity,
    required this.onErrorToast,
  });
  int limit = 10;
  bool isFirstTime = true;

  @override
  Future<Result<TodoResponse, TodoError>> getTodoList(
      GetTodoListParam param) async {
    try {
      if (param.fetchLocalOnly) {
        final todos = objectboxService.todos
            .where((todo) => todo.status == param.status)
            .toList();
        if (param.isAsc) {
          todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        }
        return Result.success(
            TodoResponse(tasks: todos, pageNumber: 1, totalPages: 1));
      }
      if (await networkConnectivity.status) {
        var result =
            await networkExecuter.execute<TodoResponseModel, TodoResponse>(
          route: ApiHolder.fetchTodoList(
              status: param.status,
              offset: param.offset,
              limit: param.limit,
              sortBy: param.sortBy,
              isAsc: param.isAsc),
          responseType: TodoResponseModel(),
        );

        return result.when(success: (data) {
          //clean all local data when first request for sync data between local and server
          if (isFirstTime) {
            objectboxService.deleteTodos();
            isFirstTime = false;
          }

          objectboxService.saveTodos(data.tasks);
          final todos = objectboxService.todos
              .where((todo) => todo.status == param.status)
              .toList();
          if (param.isAsc) {
            todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          }
          return Result.success(TodoResponse(
              pageNumber: data.pageNumber,
              totalPages: data.totalPages,
              tasks: todos));
        }, failure: (TodoError error) {
          return Result.failure(error);
        });
      } else {
        onErrorToast("No internet connection, using local data", Colors.amber,
            Colors.white);
        final todos = objectboxService.todos
            .where((todo) => todo.status == param.status)
            .toList();
        if (param.isAsc) {
          todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        }
        return Result.success(
            TodoResponse(tasks: todos, pageNumber: 1, totalPages: 1));
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
