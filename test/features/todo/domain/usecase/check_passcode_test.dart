import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/core/interface/response/result.dart';

import 'package:todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo/features/todo/domain/usecases/check_passcode.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late final CheckPasscode checkPasscode;
  late final TodoRepository mockTodoRepository;
  setUpAll(() {
    mockTodoRepository = MockTodoRepository();
    checkPasscode = CheckPasscode(mockTodoRepository);
  });
  test('should check passcode success form repo', () async {
    //arrange
    when(() => mockTodoRepository.checkPasscode("1234"))
        .thenAnswer((_) => const Result.success(true));
    //act
    final result = await checkPasscode("1234");

    //assert
    verify(() => mockTodoRepository.checkPasscode("1234"));
    result.when(success: (data) {
      expect(data, equals(true));
    }, failure: (error) {
      throw error;
    });

    verifyNoMoreInteractions(mockTodoRepository);
  });
  test('should check passcode false from repo', () async {
    when(() => mockTodoRepository.checkPasscode("1234"))
        .thenAnswer((_) => const Result.success(false));

    final result = await checkPasscode("1234");

    verify(() => mockTodoRepository.checkPasscode("1234"));

    result.when(success: (data) {
      expect(data, equals(false));
    }, failure: (error) {
      throw error;
    });

    verifyNoMoreInteractions(mockTodoRepository);
  });
}
