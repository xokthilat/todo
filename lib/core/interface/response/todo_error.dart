import 'package:dio/dio.dart';

sealed class TodoError implements Exception {}

class RequestError extends TodoError {
  final DioException error;
  RequestError({required this.error});
}

class DecodingError extends TodoError {
  final String? error;
  DecodingError({required this.error});
}

class ConnectivityError extends TodoError {
  final String? error;
  ConnectivityError({required this.error});
}

class UnknownError extends TodoError {
  final String? error;
  UnknownError({required this.error});
}

class LocalRequestError extends TodoError {
  final String? error;
  LocalRequestError({required this.error});
}
