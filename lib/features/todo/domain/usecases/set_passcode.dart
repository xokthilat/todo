import '../../../../core/interface/response/todo_error.dart';
import '../../../../core/interface/response/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class SetPasscode implements UseCase<int, String> {
  final TodoRepository todoRepository;
  SetPasscode(this.todoRepository);
  @override
  Future<Result<int, TodoError>> call(String params) async {
    return todoRepository.setPasscode(params);
  }
}
