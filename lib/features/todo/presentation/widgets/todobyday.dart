import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/style/todo_textstyle.dart';
import 'package:todo/features/todo/presentation/widgets/todo_widget.dart';

import '../../domain/entities/todo.dart';
import '../bloc/homepage/homepage_bloc.dart';

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
                  onDismissed: (direction) {
                    BlocProvider.of<HomepageBloc>(context).add(OnDeleteTodo(
                      id: todos[index].id,
                    ));
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
