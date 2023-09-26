import 'package:equatable/equatable.dart';
import 'package:todo/core/interface/response/network_error.dart';
import 'package:todo/core/interface/response/result.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type, TodoError>> call(Params params);
}

class NoParams extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
