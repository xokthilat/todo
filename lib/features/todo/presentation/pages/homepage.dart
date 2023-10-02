import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_bloc.dart';
import 'package:todo/service_locator.dart';
import '../widgets/home_header.dart';
import '../widgets/todo_listview.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

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
