import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/state/todo_state.dart';
import 'package:todo/features/todo/domain/usecases/check_passcode.dart';
import 'package:todo/features/todo/domain/usecases/set_last_online.dart';
import 'package:todo/features/todo/domain/usecases/set_last_touch.dart';
import 'package:todo/features/todo/domain/usecases/set_passcode.dart';
import 'package:todo/features/todo/presentation/bloc/passcode/passcode_bloc.dart';
import 'package:todo/features/todo/presentation/bloc/passcode/passcode_event.dart';

class MockCheckPasscode extends Mock implements CheckPasscode {}

class MockSetPasscode extends Mock implements SetPasscode {}

class MockSetLastOnline extends Mock implements SetLastOnline {}

class MockSetLastTouch extends Mock implements SetLastTouch {}

void main() {
  group('Passcode bloc', () {
    late PasscodeBloc passcodeBloc;
    late MockCheckPasscode mockCheckPasscode;
    late MockSetPasscode mockSetPasscode;
    late MockSetLastOnline mockSetLastOnline;
    late MockSetLastTouch mockSetLastTouch;

    setUp(() {
      mockCheckPasscode = MockCheckPasscode();
      mockSetPasscode = MockSetPasscode();
      mockSetLastOnline = MockSetLastOnline();
      mockSetLastTouch = MockSetLastTouch();
      passcodeBloc = PasscodeBloc(
        checkPasscode: mockCheckPasscode,
        setPasscode: mockSetPasscode,
        setLastOnline: mockSetLastOnline,
        setLastTouch: mockSetLastTouch,
      );
    });
    test('initial state is TodoLoading<bool>', () {
      expect(passcodeBloc.state, isA<TodoLoading<bool>>());
    });

    group("Success", () {
      blocTest(
        'should success when change passcode',
        setUp: () {
          when(() => mockSetPasscode(any()))
              .thenAnswer((_) async => const Result.success(1));
        },
        build: () => passcodeBloc,
        act: (bloc) => bloc.add(PasscodeChanged(passcode: "1234")),
        expect: () => [const TodoLoaded<bool>(true)],
      );
      blocTest(
        'should success when check passcode',
        setUp: () {
          when(() => mockCheckPasscode(any()))
              .thenAnswer((_) async => const Result.success(true));
          when(() => mockSetLastTouch(any()))
              .thenAnswer((_) async => const Result.success(1));
          when(() => mockSetLastOnline(any()))
              .thenAnswer((_) async => const Result.success(1));
        },
        verify: (_) {
          verify(() => mockSetLastOnline(any())).called(1);
          verify(() => mockSetLastTouch(any())).called(1);
        },
        build: () => passcodeBloc,
        act: (bloc) => bloc.add(PasscodeCheck(passcode: "1234")),
        expect: () =>
            // ignore: unused_result
            [isA<TodoLoaded<bool>>()..having((p0) => p0, "check bool", true)],
      );

      blocTest(
        'should success when set passcode',
        setUp: () {
          when(() => mockSetPasscode(any()))
              .thenAnswer((_) async => const Result.success(1));
        },
        build: () => passcodeBloc,
        act: (bloc) => bloc.add(PasscodeSet(passcode: "1234")),
        expect: () => [const TodoLoaded<bool>(true)],
      );

      blocTest(
        'should success when set last touch',
        setUp: () {
          when(() => mockSetLastTouch(any()))
              .thenAnswer((_) async => const Result.success(1));
        },
        build: () => passcodeBloc,
        act: (bloc) => bloc.add(OnLastTouchSet()),
        expect: () => [],
      );
    });
    group("fail", () {
      blocTest(
        'should fail when change passcode',
        setUp: () {
          when(() => mockSetPasscode(any())).thenAnswer(
              (_) async => Result.failure(LocalRequestError(errMsg: "")));
        },
        build: () => passcodeBloc,
        act: (bloc) => bloc.add(PasscodeChanged(passcode: "1234")),
        expect: () => [isA<TodoErrorState>()],
      );
      blocTest(
        'should fail when check passcode',
        setUp: () {
          when(() => mockCheckPasscode(any())).thenAnswer(
              (_) async => Result.failure(LocalRequestError(errMsg: "")));
          when(() => mockSetLastTouch(any()))
              .thenAnswer((_) async => const Result.success(1));
          when(() => mockSetLastOnline(any()))
              .thenAnswer((_) async => const Result.success(1));
        },
        verify: (_) {
          verify(() => mockSetLastOnline(any())).called(1);
          verify(() => mockSetLastTouch(any())).called(1);
        },
        build: () => passcodeBloc,
        act: (bloc) => bloc.add(PasscodeCheck(passcode: "1234")),
        expect: () => [isA<TodoErrorState>()],
      );

      blocTest(
        'should fail when set passcode',
        setUp: () {
          when(() => mockSetPasscode(any())).thenAnswer(
              (_) async => Result.failure(LocalRequestError(errMsg: "")));
        },
        build: () => passcodeBloc,
        act: (bloc) => bloc.add(PasscodeSet(passcode: "1234")),
        expect: () => [isA<TodoErrorState>()],
      );

      blocTest(
        'should fail when set last touch',
        setUp: () {
          when(() => mockSetLastTouch(any())).thenAnswer(
              (_) async => Result.failure(LocalRequestError(errMsg: "")));
        },
        build: () => passcodeBloc,
        act: (bloc) => bloc.add(OnLastTouchSet()),
        expect: () => [isA<TodoErrorState>()],
      );
    });
  });
}
