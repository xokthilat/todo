import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo/core/style/todo_textstyle.dart';
import 'package:todo/features/todo/domain/entities/todo.dart';

import '../../../../core/router/todo_navigator.dart';
import '../../../../service_locator.dart';
import '../bloc/homepage/homepage_bloc.dart';

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
          child: CachedNetworkImage(
            imageUrl: 'https://picsum.photos/250?image=9',
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
