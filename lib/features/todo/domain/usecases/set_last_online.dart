import '../../../../core/interface/response/todo_error.dart';
import '../../../../core/interface/response/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class SetLastOnline implements UseCase<int, DateTime> {
  final TodoRepository todoRepository;
  SetLastOnline(this.todoRepository);
  @override
  Future<Result<int, TodoError>> call(DateTime params) async {
    return todoRepository.setLastOnline(params);
  }
}
