import 'package:flutter/material.dart';
import 'model/todo.dart';
import 'todos_bloc.dart';

class Testwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllTodos();
    return Container(
      width: 100,
      height: 200,
      child: StreamBuilder(
        stream: bloc.allTodos,
        builder: (context, AsyncSnapshot<Todo> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.title);
          } else {
            return Text(snapshot.data.toString());
          }
        },
      ),
    );
  }
}
