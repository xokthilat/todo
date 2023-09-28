import 'package:dio/dio.dart';

sealed class TodoError implements Exception {
  final String? errMsg;

  TodoError({required this.errMsg});

  String get message => "Error : $errMsg";
}

class RequestError extends TodoError {
  final DioException error;
  RequestError({required this.error, String? errMsg}) : super(errMsg: errMsg);
}

class DecodingError extends TodoError {
  DecodingError({required String errMsg}) : super(errMsg: errMsg);
}

class ConnectivityError extends TodoError {
  ConnectivityError({required String errMsg}) : super(errMsg: errMsg);
}

class UnknownError extends TodoError {
  UnknownError({required String errMsg}) : super(errMsg: errMsg);
}

class LocalRequestError extends TodoError {
  LocalRequestError({required String errMsg}) : super(errMsg: errMsg);
}
