import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/router/router.dart';
import 'package:todo/core/router/todo_navigator.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_bloc.dart';
import 'package:todo/service_locator.dart';

import 'features/todo/presentation/bloc/homepage/header_cubit.dart';
import 'features/todo/presentation/bloc/passcode/passcode_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PasscodeBloc>(
          create: (context) => sl<PasscodeBloc>(),
        ),
        BlocProvider<HomepageBloc>(
          create: (context) => sl<HomepageBloc>(),
        ),
        BlocProvider<HeaderCubit>(
          create: (context) => sl<HeaderCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Todo',
        navigatorKey: sl<TodoNavigator>().navigatorKey,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
