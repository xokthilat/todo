import 'package:equatable/equatable.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:todo/core/interface/models/base_network_model.dart';
part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel extends BaseNetworkModel<TodoModel>
    with EquatableMixin
    implements Todo {
  @override
  late final DateTime createdAt;

  @override
  late final String description;

  @override
  late final String id;

  @override
  late final TodoStatus status;

  @override
  late final String title;

  @override
  List<Object?> get props => [id, title, description, createdAt, status];

  @override
  TodoModel fromJson(Map<String, dynamic> json) {
    return _$TodoModelFromJson(json);
  }
}
