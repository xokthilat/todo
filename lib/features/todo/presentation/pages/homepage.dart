import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo/constants.dart';
import 'package:todo/core/router/todo_navigator.dart';
import 'package:todo/core/style/todo_textstyle.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_bloc.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_event.dart';
import 'package:todo/service_locator.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/state/todo_state.dart';
import '../bloc/homepage/homepage_state.dart';
import '../widgets/chip_tab.dart';
import 'passcode_page.dart';

String formatRelativeDate(DateTime date) {
  final now = DateTime.now();
  final difference = date.difference(now).inDays;
  final isYesterday = (difference <= 1 && difference >= -1) &&
          (date.day == DateTime.now().subtract(const Duration(days: 1)).day)
      ? true
      : false;
  final isTomorrow = (difference <= 1 && difference >= -1) &&
          (date.day == DateTime.now().add(const Duration(days: 1)).day)
      ? true
      : false;
  if (isYesterday) return "Yesterday";
  if (isTomorrow) return "Tomorrow";
  final dateFormat = DateFormat('MMMM d, y');
  return dateFormat.format(date);
}

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
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Lorem Ipsum".h1.highlightColor,
                                  Builder(builder: (ctx) {
                                    return InkWell(
                                      onTap: () {
                                        BlocProvider.of<HomepageBloc>(ctx)
                                            .add(OnStopInactiveValidation());
                                        sl<TodoNavigator>()
                                            .navigateTo(AppRoute.passcode,
                                                params:
                                                    PasscodePageParams.change)
                                            .then((_) {
                                          BlocProvider.of<HomepageBloc>(ctx)
                                              .add(OnStartInactiveValidation());
                                        });
                                      },
                                      child: const Icon(
                                        Icons.settings,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    );
                                  })
                                ],
                              ),
                              "Lorem ipsum sit amet.".pBold.highlightColor,
                              "consectetur adipiscing elit, tempor."
                                  .pBold
                                  .highlightColor,
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                  Positioned(
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 80,
                          decoration: BoxDecoration(
                              color: greyColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: BlocBuilder<HomepageBloc,
                                TodoState<HomepageState>>(
                              builder: (context, state) {
                                if (state is TodoLoaded<HomepageState>) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: ChipTab(
                                          isActive: state.data.pageStatus ==
                                              PageStatus.todo,
                                          text: "To-Do",
                                          onTap: () => BlocProvider.of<
                                                  HomepageBloc>(context)
                                              .add(FetchHomeData(
                                                  pageStatus: PageStatus.todo)),
                                        ),
                                      ),
                                      Expanded(
                                        child: ChipTab(
                                          isActive: state.data.pageStatus ==
                                              PageStatus.doing,
                                          text: "Doing",
                                          onTap: () =>
                                              BlocProvider.of<HomepageBloc>(
                                                      context)
                                                  .add(FetchHomeData(
                                                      pageStatus:
                                                          PageStatus.doing)),
                                        ),
                                      ),
                                      Expanded(
                                        child: ChipTab(
                                          isActive: state.data.pageStatus ==
                                              PageStatus.done,
                                          text: "Done",
                                          onTap: () => BlocProvider.of<
                                                  HomepageBloc>(context)
                                              .add(FetchHomeData(
                                                  pageStatus: PageStatus.done)),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: BlocBuilder<HomepageBloc, TodoState<HomepageState>>(
                    builder: (context, state) {
                      ScrollController scrollController = ScrollController();

                      scrollController.addListener(() {
                        if (scrollController.position.pixels ==
                            scrollController.position.maxScrollExtent) {
                          BlocProvider.of<HomepageBloc>(context)
                              .add(FetchHomeData(pageStatus: PageStatus.todo));
                        }
                      });
                      switch (state) {
                        case TodoLoading<HomepageState>():
                          return "Loading".pBold.highlightColor;
                        case TodoLoaded<HomepageState>(data: var data):
                          if (data.todos.isEmpty) {
                            return "No data".pBold.highlightColor;
                          }
                          return SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                  data.todos.groupByDate.keys.length, (index) {
                                final groupedByDate = data.todos.groupByDate;
                                return Column(
                                  children: [
                                    TodoByDay(
                                      todos:
                                          groupedByDate.values.toList()[index],
                                      title: formatRelativeDate(DateTime.parse(
                                          groupedByDate.keys.toList()[index])),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          );
                        case TodoErrorState<HomepageState>(error: var err):
                          return err.message.pBold.highlightColor;
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TodoByDay extends StatelessWidget {
  final List<Todo> todos;
  final String title;
  const TodoByDay({
    super.key,
    required this.todos,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.h3.blackColor,
        const SizedBox(
          height: 10,
        ),
        ...List.generate(
            todos.length,
            (index) => Dismissible(
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(
                          width: 40,
                        )
                      ],
                    ),
                  ),
                  key: Key(todos[index].id),
                  // Provide a function that tells the app
                  // what to do after an item has been swiped away.
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    BlocProvider.of<HomepageBloc>(context).add(OnDeleteTodo(
                      id: todos[index].id,
                    ));
                    // Then show a snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${todos[index].title} dismissed')));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: TodoWidget(todo: todos[index]),
                  ),
                ))
      ],
    );
  }
}

class TodoWidget extends StatelessWidget {
  const TodoWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://picsum.photos/250?image=9',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 3,
              ),
              todo.title.pBold.blackColor,
              todo.description.p.blackColor,
            ],
          ),
        ),
        Column(
          children: [
            InkWell(
              onTap: () => PanaraConfirmDialog.show(
                context,
                title: "Warning",
                message: "Are you sure you want to delete this task?",
                panaraDialogType: PanaraDialogType.error,
                barrierDismissible: true,
                confirmButtonText: 'Yes',
                cancelButtonText: 'No',
                onTapConfirm: () {
                  BlocProvider.of<HomepageBloc>(context)
                      .add(OnDeleteTodo(id: todo.id));
                  sl<TodoNavigator>().popBack();
                  Fluttertoast.showToast(msg: "${todo.title} deleted");
                },
                onTapCancel: () {
                  sl<TodoNavigator>().popBack();
                },
              ),
              //make minus icon
              child: const Icon(
                Icons.clear,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ],
        )
      ],
    );
  }
}
