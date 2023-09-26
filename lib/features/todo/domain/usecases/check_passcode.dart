import 'package:todo/features/todo/domain/repositories/todo_repository.dart';

import '../../../../core/interface/response/todo_error.dart';
import '../../../../core/interface/response/result.dart';
import '../../../../core/usecases/usecase.dart';

class CheckPasscode implements UseCase<bool, int> {
  final TodoRepository todoRepository;
  CheckPasscode(this.todoRepository);
  @override
  Future<Result<bool, TodoError>> call(int params) async {
    return todoRepository.checkPasscode(params);
  }
}
