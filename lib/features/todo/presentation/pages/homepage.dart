import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo/constants.dart';
import 'package:todo/core/router/todo_navigator.dart';
import 'package:todo/core/style/todo_textstyle.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_bloc.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_event.dart';
import 'package:todo/service_locator.dart';

import '../../../../core/interface/response/todo_error.dart';
import '../../../../core/state/todo_state.dart';
import '../../domain/entities/todo.dart';
import '../bloc/homepage/homepage_state.dart';
import '../widgets/chip_tab.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<HomepageBloc>()..add(FetchHomeData(pageStatus: PageStatus.todo)),
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
                            "Lorem Ipsum".h1.highlightColor,
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
                                      ),
                                    ),
                                    Expanded(
                                      child: ChipTab(
                                        isActive: state.data.pageStatus ==
                                            PageStatus.doing,
                                        text: "Doing",
                                      ),
                                    ),
                                    Expanded(
                                      child: ChipTab(
                                        isActive: state.data.pageStatus ==
                                            PageStatus.done,
                                        text: "Done",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: BlocBuilder<HomepageBloc, TodoState<HomepageState>>(
                  builder: (context, state) {
                    if (state is TodoErrorState<HomepageState>) {
                      return state.error.message.pBold.highlightColor;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TodoByDay(),
                        SizedBox(
                          height: 30,
                        ),
                        TodoByDay(),
                        SizedBox(
                          height: 30,
                        ),
                        TodoByDay(),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TodoByDay extends StatelessWidget {
  const TodoByDay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Today".h3.blackColor,
        const SizedBox(
          height: 10,
        ),
        Row(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 3,
                ),
                "Lorem Ipsum".pBold.blackColor,
                "Lorem ipsum sit amet.".p.blackColor,
              ],
            ),
            const Spacer(),
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
                    onTapConfirm: () {},
                    onTapCancel: () {
                      //popback
                      sl<TodoNavigator>().popBack();
                    }, // optional parameter (default is true)
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
        )
      ],
    );
  }
}
