// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo/core/interface/api_client/base_client_generator.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

import '../../api_config.dart';
part 'api_holder.freezed.dart';

@freezed
class ApiHolder extends BaseClientGenerator with _$ApiHolder {
  const ApiHolder._() : super();
  const factory ApiHolder.fetchTodoList(
      {required int offset,
      required int limit,
      required String sortBy,
      required bool isAsc,
      required TodoStatus status}) = _FetchTodoList;
  @override
  String get baseURL => baseUrl;

  @override
  Map<String, dynamic> get header {
    return maybeWhen<Map<String, dynamic>>(
        orElse: () => {"Content-Type": "application/json"});
  }

  @override
  String get path {
    return when<String>(
        fetchTodoList: (offset, limit, sortBy, isAsc, status) => "todo-list");
  }

  @override
  String get method {
    return maybeWhen<String>(
      orElse: () => 'GET',
    );
  }

  @override
  dynamic get body {
    return maybeWhen(
      orElse: () {
        return null;
      },
    );
  }

  @override
  Map<String, dynamic>? get queryParameters {
    return when(
      fetchTodoList: (offset, limit, sortBy, isAsc, status) => {
        "offset": offset,
        "limit": limit,
        "sortBy": sortBy,
        "isAsc": isAsc,
        "status": status.name,
      },
    );
  }
}
