// ignore_for_file: unused_result

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/core/entities/todo_response.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/state/todo_state.dart';
import 'package:todo/features/todo/data/dao/todo_dao.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';
import 'package:todo/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo/features/todo/domain/usecases/get_auth_detail.dart';
import 'package:todo/features/todo/domain/usecases/get_todo_list.dart';
import 'package:todo/features/todo/domain/usecases/set_last_online.dart';
import 'package:todo/features/todo/domain/usecases/set_last_touch.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_bloc.dart';

class MockGetTodoList extends Mock implements GetTodoList {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

class MockSetLastOnline extends Mock implements SetLastOnline {}

class MockSetLastTouch extends Mock implements SetLastTouch {}

class MockGetAuthDetail extends Mock implements GetAuthDetail {}

void main() {
  var fakeTodo = TodoDao(
      description: "description",
      title: "title",
      createdAt: DateTime.now(),
      id: "1");
  fakeTodo.dbStatus = 0;
  var fakeTodoRes =
      TodoResponse(pageNumber: 1, totalPages: 1, tasks: [fakeTodo]);

  const offset = 0;
  const limit = 10;
  const sortBy = "createdAt";
  const isAsc = false;
  const status = TodoStatus.TODO;
  group('Homepage bloc', () {
    late HomepageBloc homepageBloc;
    late MockGetTodoList mockGetTodoList;
    late MockDeleteTodo mockDeleteTodo;
    late MockSetLastOnline mockSetLastOnline;
    late MockSetLastTouch mockSetLastTouch;
    late MockGetAuthDetail mockGetAuthDetail;

    setUp(() {
      mockGetTodoList = MockGetTodoList();
      mockDeleteTodo = MockDeleteTodo();
      mockSetLastOnline = MockSetLastOnline();
      mockSetLastTouch = MockSetLastTouch();
      mockGetAuthDetail = MockGetAuthDetail();
      homepageBloc = HomepageBloc(
        getTodoList: mockGetTodoList,
        deleteTodo: mockDeleteTodo,
        setLastOnline: mockSetLastOnline,
        setLastTouch: mockSetLastTouch,
        getAuthDetail: mockGetAuthDetail,
      );
      registerFallbackValue(TodoStatus.TODO);
      registerFallbackValue(GetTodoListParam(
          status: status,
          fetchLocalOnly: false,
          limit: limit,
          sortBy: sortBy,
          isAsc: isAsc,
          offset: offset));
    });
    test('initial state is TodoLoading<bool>', () {
      expect(homepageBloc.state, isA<TodoLoading<HomepageState>>());
    });

    group("Success", () {
      blocTest(
        'should success when FetchHomeData',
        setUp: () {
          when(() => mockGetTodoList(any()))
              .thenAnswer((_) async => Result.success(fakeTodoRes));
        },
        build: () => homepageBloc,
        act: (bloc) => bloc.add(FetchHomeData(pageStatus: PageStatus.todo)),
        expect: () => [
          isA<TodoLoading<HomepageState>>(),
          isA<TodoLoaded<HomepageState>>()
            ..having(
                (p0) => p0,
                "",
                HomepageState(
                  todos: fakeTodoRes.tasks,
                  pageStatus: PageStatus.todo,
                  isFinalPage: fakeTodoRes.totalPages == fakeTodoRes.pageNumber,
                  currentPage: fakeTodoRes.pageNumber,
                ))
        ],
      );
      blocTest(
        'should success when OnSubmitLastTouch',
        setUp: () {
          when(() => mockSetLastTouch(any()))
              .thenAnswer((_) async => const Result.success(1));
        },
        build: () => homepageBloc,
        act: (bloc) => bloc.add(OnSubmitLastTouch()),
        expect: () => [],
      );
      blocTest(
        'should success when OnSubmitLastOnline',
        setUp: () {
          when(() => mockSetLastOnline(any()))
              .thenAnswer((_) async => const Result.success(1));
        },
        build: () => homepageBloc,
        act: (bloc) => bloc.add(OnSubmitLastOnline()),
        expect: () => [],
      );

      blocTest<HomepageBloc, TodoState<HomepageState>>(
        'should success when OnDeleteTodo',
        setUp: () {
          when(() => mockDeleteTodo(any()))
              .thenAnswer((_) async => const Result.success(true));
          when(() => mockGetTodoList(any()))
              .thenAnswer((_) async => Result.success(fakeTodoRes));
        },
        seed: () => TodoLoaded<HomepageState>(HomepageState(
          todos: fakeTodoRes.tasks,
          pageStatus: PageStatus.todo,
          isFinalPage: fakeTodoRes.totalPages == fakeTodoRes.pageNumber,
          currentPage: fakeTodoRes.pageNumber,
        )),
        build: () => homepageBloc,
        act: (bloc) => bloc.add(OnDeleteTodo(
          id: "1",
        )),
        verify: (bloc) {
          verify(() => mockGetTodoList(any())).called(1);
          verify(() => mockDeleteTodo(any())).called(1);
        },
        expect: () => [
          isA<TodoLoading<HomepageState>>(),
          isA<TodoLoaded<HomepageState>>()
            ..having(
                (p0) => p0,
                "",
                HomepageState(
                  todos: fakeTodoRes.tasks,
                  pageStatus: PageStatus.todo,
                  isFinalPage: fakeTodoRes.totalPages == fakeTodoRes.pageNumber,
                  currentPage: fakeTodoRes.pageNumber,
                ))
        ],
      );
      blocTest(
        'should success when OnPageChanged',
        setUp: () {
          when(() => mockGetTodoList(any()))
              .thenAnswer((_) async => Result.success(fakeTodoRes));
          when(() => mockGetTodoList(any()))
              .thenAnswer((_) async => Result.success(fakeTodoRes));
        },
        build: () => homepageBloc,
        act: (bloc) => bloc.add(OnPageChanged(
          pageStatus: PageStatus.todo,
        )),
        expect: () => [
          isA<TodoLoading<HomepageState>>(),
          isA<TodoLoading<HomepageState>>(),
          isA<TodoLoaded<HomepageState>>()
            ..having(
                (p0) => p0,
                "",
                HomepageState(
                  todos: fakeTodoRes.tasks,
                  pageStatus: PageStatus.todo,
                  isFinalPage: fakeTodoRes.totalPages == fakeTodoRes.pageNumber,
                  currentPage: fakeTodoRes.pageNumber,
                ))
        ],
      );
    });
    group("fail", () {
      blocTest(
        'should fail when FetchHomeData',
        setUp: () {
          when(() => mockGetTodoList(any())).thenAnswer((_) async =>
              Result.failure(RequestError(
                  error: DioException(requestOptions: RequestOptions()))));
        },
        build: () => homepageBloc,
        act: (bloc) => bloc.add(FetchHomeData(pageStatus: PageStatus.todo)),
        expect: () => [
          isA<TodoLoading<HomepageState>>(),
          isA<TodoErrorState<HomepageState>>()
            ..having(
                (p0) => p0,
                "",
                RequestError(
                    error: DioException(requestOptions: RequestOptions())))
        ],
      );
      blocTest(
        'should fail when OnSubmitLastTouch',
        setUp: () {
          when(() => mockSetLastTouch(any())).thenAnswer(
              (_) async => Result.failure(LocalRequestError(errMsg: "")));
        },
        build: () => homepageBloc,
        act: (bloc) => bloc.add(OnSubmitLastTouch()),
        expect: () => [
          isA<TodoErrorState<HomepageState>>()
            ..having((p0) => p0, "", LocalRequestError(errMsg: ""))
        ],
      );
      blocTest(
        'should fail when OnSubmitLastOnline',
        setUp: () {
          when(() => mockSetLastOnline(any())).thenAnswer(
              (_) async => Result.failure(LocalRequestError(errMsg: "")));
        },
        build: () => homepageBloc,
        act: (bloc) => bloc.add(OnSubmitLastOnline()),
        expect: () => [
          isA<TodoErrorState<HomepageState>>()
            ..having((p0) => p0, "", LocalRequestError(errMsg: ""))
        ],
      );
    });
  });
}
