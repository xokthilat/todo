import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo/features/todo/domain/usecases/delete_todo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late DeleteTodo usecase;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = DeleteTodo(mockTodoRepository);
  });

  const tId = '1';

  test(
    'should delete todo from the repository',
    () async {
      // arrange
      when(() => mockTodoRepository.deleteTodoList(any()))
          .thenReturn(const Result.success(true));
      // act
      final result = await usecase(tId);
      // assert
      result.when(success: (data) {
        expect(data, true);
      }, failure: (error) {
        throw error;
      });
      verify(() => mockTodoRepository.deleteTodoList(tId)).called(1);
      verifyNoMoreInteractions(mockTodoRepository);
    },
  );

  test(
    'should get error when delete todo from the repository',
    () async {
      // arrange
      when(() => mockTodoRepository.deleteTodoList(any()))
          .thenReturn(Result.failure(LocalRequestError(errMsg: "error")));
      // act
      final result = await usecase(tId);
      // assert
      result.when(success: (data) {
        throw data;
      }, failure: (error) {
        expect(error, isA<LocalRequestError>());
      });
      verify(() => mockTodoRepository.deleteTodoList(tId)).called(1);
      verifyNoMoreInteractions(mockTodoRepository);
    },
  );
}
