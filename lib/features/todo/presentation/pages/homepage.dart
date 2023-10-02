import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_bloc.dart';
import 'package:todo/service_locator.dart';
import '../widgets/home_header.dart';
import '../widgets/todo_listview.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      sl<HomepageBloc>().add(OnSubmitLastTouch());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomepageBloc>()
        ..add(FetchHomeData(pageStatus: PageStatus.todo))
        ..add(OnStartInactiveValidation()),
      child: TapRegion(
        onTapInside: (event) => sl<HomepageBloc>().add(OnSubmitLastTouch()),
        child: const Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              HomeHeader(),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: TodoListView(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
