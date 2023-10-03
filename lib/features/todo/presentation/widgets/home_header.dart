import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/style/todo_textstyle.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/header_cubit.dart';

import '../../../../constants.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/router/todo_navigator.dart';
import '../../../../service_locator.dart';
import '../bloc/homepage/homepage_bloc.dart';
import '../pages/passcode_page.dart';
import 'chip_tab.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Lorem Ipsum".h1.highlightColor,
                        Builder(builder: (ctx) {
                          return InkWell(
                            onTap: () {
                              BlocProvider.of<HomepageBloc>(ctx)
                                  .add(OnStopInactiveValidation());
                              sl<TodoNavigator>()
                                  .navigateTo(AppRoute.passcode,
                                      params: PasscodePageParams.change)
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
                    "consectetur adipiscing elit, tempor.".pBold.highlightColor,
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
                    color: greyColor, borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: BlocBuilder<HeaderCubit, PageStatus>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: ChipTab(
                              isActive: state == PageStatus.todo,
                              text: "To-Do",
                              onTap: () => BlocProvider.of<HeaderCubit>(context)
                                  .changePage(PageStatus.todo),
                            ),
                          ),
                          Expanded(
                            child: ChipTab(
                              isActive: state == PageStatus.doing,
                              text: "Doing",
                              onTap: () => BlocProvider.of<HeaderCubit>(context)
                                  .changePage(PageStatus.doing),
                            ),
                          ),
                          Expanded(
                            child: ChipTab(
                              isActive: state == PageStatus.done,
                              text: "Done",
                              onTap: () => BlocProvider.of<HeaderCubit>(context)
                                  .changePage(PageStatus.done),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
