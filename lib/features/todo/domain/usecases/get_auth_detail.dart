import 'package:todo/core/interface/response/result.dart';

import '../../../../core/interface/response/todo_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth.dart';
import '../repositories/todo_repository.dart';

class GetAuthDetail implements UseCase<Auth?, NoParams> {
  final TodoRepository todoRepository;
  GetAuthDetail(this.todoRepository);
  @override
  Future<Result<Auth?, TodoError>> call(NoParams params) async {
    return todoRepository.getAuthDetail;
  }
}
