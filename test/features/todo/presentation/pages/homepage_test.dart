import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/state/todo_state.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/header_cubit.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_bloc.dart';
import 'package:todo/features/todo/presentation/pages/homepage.dart';

class MockHomepageBloc extends MockBloc<HomepageEvent, TodoState<HomepageState>>
    implements HomepageBloc {}

class MockHeaderCubit extends MockCubit<PageStatus> implements HeaderCubit {}

void main() {
  testWidgets('should show loading when initial state is loading',
      (WidgetTester tester) async {
    // arrange
    final mockHomepageBloc = MockHomepageBloc();
    final mockHeaderCubit = MockHeaderCubit();
    when(() => mockHomepageBloc.state).thenReturn(
      TodoLoading<HomepageState>(), // the desired state
    );
    when(
      () => mockHeaderCubit.state,
    ).thenReturn(PageStatus.todo);

    const widget = Homepage();
    final messageWidget = find.text("Loading");

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<HomepageBloc>(
            create: (context) => mockHomepageBloc,
          ),
          BlocProvider<HeaderCubit>(
            create: (context) => mockHeaderCubit,
          ),
        ],
        child: const MaterialApp(
          title: 'Widget Test',
          home: widget,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(messageWidget, findsOneWidget);
  });

  testWidgets('should show error when state is error',
      (WidgetTester tester) async {
    const errorText = "local error";
    // arrange
    final mockHomepageBloc = MockHomepageBloc();
    final mockHeaderCubit = MockHeaderCubit();
    when(() => mockHomepageBloc.state).thenReturn(
      TodoErrorState<HomepageState>(
          LocalRequestError(errMsg: errorText)), // the desired state
    );
    when(
      () => mockHeaderCubit.state,
    ).thenReturn(PageStatus.todo);

    const widget = Homepage();
    final messageWidget = find.text("Error : local error");

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<HomepageBloc>(
            create: (context) => mockHomepageBloc,
          ),
          BlocProvider<HeaderCubit>(
            create: (context) => mockHeaderCubit,
          ),
        ],
        child: const MaterialApp(
          title: 'Widget Test',
          home: widget,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(messageWidget, findsOneWidget);
  });

  testWidgets("should show content when state is loaded", (widgetTester) async {
    final listTodo = [
      Todo()
        ..title = "Todo"
        ..createdAt = DateTime.now()
        ..description = "description"
        ..id = "1"
        ..status = TodoStatus.TODO
    ];
    // arrange
    final mockHomepageBloc = MockHomepageBloc();
    final mockHeaderCubit = MockHeaderCubit();
    when(() => mockHomepageBloc.state).thenReturn(
      TodoLoaded<HomepageState>(HomepageState(
        todos: listTodo,
        currentPage: 0,
        pageStatus: PageStatus.todo,
      )), // the desired state
    );
    when(
      () => mockHeaderCubit.state,
    ).thenReturn(PageStatus.todo);

    const widget = Homepage(
      shouldEnableImage: false,
    );
    final messageWidget = find.text("Todo");

    await widgetTester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<HomepageBloc>(
            create: (context) => mockHomepageBloc,
          ),
          BlocProvider<HeaderCubit>(
            create: (context) => mockHeaderCubit,
          ),
        ],
        child: const MaterialApp(
          title: 'Widget Test',
          home: widget,
        ),
      ),
    );
    for (int i = 0; i < 5; i++) {
      await widgetTester.pump(const Duration(seconds: 1));
    }
    expect(messageWidget, findsOneWidget);
  });
}
