import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/core/state/todo_state.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/header_cubit.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_bloc.dart';
import 'package:todo/main.dart';
import 'package:todo/service_locator.dart';

import '../test/test_navigator_observe.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await init();
    registerFallbackValue(Route<dynamic>);
  });
  group('end-to-end test', () {
    testWidgets('Happy flow', (tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.text('Enter App Passcode'), findsOneWidget);

      //1. the default passcode is 123456 so we enter 111111 to get an error
      final oneButton = find.byKey(const Key('1'));

      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);

      //keep in mind that we need to wait for the animation to finish but pumpAndSettle doesn't work here so we need to create a custom pumpAndSettle
      while (tester.binding.transientCallbackCount > 1) {
        await tester.pump();
      }

      expect(find.text('Enter App Passcode'), findsOneWidget);

      //2. start with the correct passcode

      final twoButton = find.byKey(const Key('2'));
      final threeButton = find.byKey(const Key('3'));
      final fourButton = find.byKey(const Key('4'));
      final fiveButton = find.byKey(const Key('5'));
      final sixButton = find.byKey(const Key('6'));
      for (int i = 0; i < 6; i++) {
        await tester.tap(find.text("Delete"));
      }
      await tester.tap(oneButton);
      await tester.tap(twoButton);
      await tester.tap(threeButton);
      await tester.tap(fourButton);
      await tester.tap(fiveButton);
      await tester.tap(sixButton);

//keep in mind that we need to wait for the animation to finish but pumpAndSettle doesn't work here so we need to create a custom pumpAndSettle
      while (tester.binding.transientCallbackCount > 1) {
        await tester.pump();
      }
      //3. passcode is fine enter homepage and fetch todo
      expect(find.text('Loading'), findsOneWidget);

      while (sl<HomepageBloc>().state is! TodoLoaded<HomepageState>) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('Read a book'), findsOneWidget);

      expect(find.text('Enter App Passcode'), findsNothing);

      //4. switch to doing page

      await tester.tap(find.byKey(const Key("doing")));

      while (sl<HomepageBloc>().state is! TodoLoaded<HomepageState> ||
          sl<HeaderCubit>().state != PageStatus.doing ||
          tester.binding.transientCallbackCount > 1) {
        await tester.pump(const Duration());
      }
      expect(find.text('The best way to predict the future is to invent it.'),
          findsOneWidget);

      //5. switch to done

      await tester.tap(find.byKey(const Key("done")));

      while (sl<HomepageBloc>().state is! TodoLoaded<HomepageState> ||
          sl<HeaderCubit>().state != PageStatus.done ||
          tester.binding.transientCallbackCount > 1) {
        await tester.pump(const Duration());
      }
      expect(find.text('Levitating - Dua Lipa ft. DaBaby'), findsOneWidget);

      //swipe to delete todo
      await tester.drag(
          find.byKey(const Key("9dd9316f-39d2-4ef1-bfc6-45df0b847881")),
          const Offset(500, 0));

      while (tester.binding.transientCallbackCount > 1) {
        await tester.pump();
      }

      expect(find.text('Levitating - Dua Lipa ft. DaBaby'), findsNothing);

      await tester.tap(find.byKey(const Key("settings")));

      while (tester.binding.transientCallbackCount > 1) {
        await tester.pump();
      }

      expect(find.text('Change App Passcode'), findsOneWidget);

      //6. change password to 111111
      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);

      while (tester.binding.transientCallbackCount > 1) {
        await tester.pump();
      }
      //7. passcode is fine enter homepage and fetch todo

      while (sl<HomepageBloc>().state is! TodoLoaded<HomepageState>) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('Read a book'), findsOneWidget);

      expect(find.text('Enter App Passcode'), findsNothing);

      //8. freezed app for 10s and then lock it

      while (tester.binding.transientCallbackCount > 1) {
        await tester.pump();
      }

      //9. add more 2s for widget to finish animation
      await Future.delayed(const Duration(seconds: 10 + 2));

      while (tester.binding.transientCallbackCount > 1) {
        await tester.pump();
      }
      expect(find.text('Enter App Passcode'), findsOneWidget);

//10. after lock we should be able to enter the app with the new passcode
      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);
      await tester.tap(oneButton);

      while (tester.binding.transientCallbackCount > 1) {
        await tester.pump();
      }
      //11. passcode is fine enter homepage and fetch todo
      expect(find.text('Read a book'), findsOneWidget);

      //12. switch back to todo page

      await tester.tap(find.byKey(const Key("todo")));

      while (sl<HomepageBloc>().state is! TodoLoaded<HomepageState> ||
          sl<HeaderCubit>().state != PageStatus.todo ||
          tester.binding.transientCallbackCount > 1) {
        await tester.pump(const Duration());
      }
      expect(find.text('Read a book'), findsOneWidget);
      final listFinder = find.byType(Scrollable);
      final itemFinder = find.text("Buy groceries");

      await tester.scrollUntilVisible(itemFinder, 500.0,
          scrollable: listFinder, duration: Duration(seconds: 2));
      expect(itemFinder, findsOneWidget);
    });
  });
}
