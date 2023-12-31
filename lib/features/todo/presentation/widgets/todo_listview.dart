import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/style/todo_textstyle.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';
import 'package:todo/features/todo/presentation/widgets/todobyday.dart';

import '../../../../constants.dart';
import '../../../../core/state/todo_state.dart';
import '../bloc/homepage/homepage_bloc.dart';

class TodoListView extends StatelessWidget {
  final bool shouldEnableImage;
  const TodoListView({
    super.key,
    this.shouldEnableImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: BlocBuilder<HomepageBloc, TodoState<HomepageState>>(
        builder: (context, state) {
          ScrollController scrollController = ScrollController();

          switch (state) {
            case TodoLoading<HomepageState>():
              return "Loading".pBold.highlightColor;
            case TodoLoaded<HomepageState>(data: var data):
              if (data.todos.isEmpty) {
                return "No data".pBold.highlightColor;
              }

              // add -50 becase we want to make it load before the end of the list
              scrollController.addListener(() {
                if (scrollController.position.pixels >
                    (scrollController.position.maxScrollExtent - 50)) {
                  BlocProvider.of<HomepageBloc>(context)
                      .add(OnFetchMore(pageStatus: state.data.pageStatus));
                }
              });
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          data.todos.groupByDate.keys.length, (index) {
                        final groupedByDate = data.todos.groupByDate;

                        return Column(
                          children: [
                            TodoByDay(
                              todos: groupedByDate.values.toList()[index],
                              title: formatRelativeDate(DateTime.parse(
                                  groupedByDate.keys.toList()[index])),
                              shouldEnableImage: shouldEnableImage,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }),
                    ),
                    Visibility(
                      visible: !data.isFinalPage,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              );
            case TodoErrorState<HomepageState>(error: var err):
              return err.message.pBold.highlightColor;
          }
        },
      ),
    );
  }
}
