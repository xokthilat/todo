import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';
part 'todo_error.freezed.dart';

@freezed
class TodoError with _$TodoError implements Exception {
  const TodoError._() : super();

  const factory TodoError.request({required DioException error}) =
      _ResponseError;
  const factory TodoError.type({String? error}) = _DecodingError;
  const factory TodoError.connectivity({String? message}) = _Connectivity;
}
