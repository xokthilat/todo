// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) => TodoModel()
  ..createdAt = DateTime.parse(json['createdAt'] as String)
  ..description = json['description'] as String
  ..id = json['id'] as String
  ..status = $enumDecode(_$TodoStatusEnumMap, json['status'])
  ..title = json['title'] as String;

const _$TodoStatusEnumMap = {
  TodoStatus.TODO: 'TODO',
  TodoStatus.DOING: 'DOING',
  TodoStatus.DONE: 'DONE',
  TodoStatus.UNKNOWN: 'UNKNOWN',
};
