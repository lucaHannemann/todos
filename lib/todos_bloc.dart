import 'package:Todo/model/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'resources/todoRepository.dart';
import 'model/todo.dart';

class TodosBloc {
  final _repository = TodoRepository();
  final _todofetcher = PublishSubject<Todo>();

  Stream<Todo> get allTodos => _todofetcher.stream;

  fetchAllTodos() async {
    Todo todo = await _repository.fetchAllTodos();
    _todofetcher.sink.add(todo);
  }

  dispose() {
    _todofetcher.close();
  }
}

final bloc = TodosBloc();
/*class TodosBloc {
  final _todosController = BehaviorSubject<List<Todo>>();

  BehaviorSubject<List<Todo>> get todosController => _todosController;

  Stream<List<Todo>> get todos$ => _todosController.stream;

  loadTodos() {
    this.repository.loadTodos().then((todos) {
      _todosController.add(todos);
    });
  }

  removeTodo(String id) {
    final todos = (_todosController.value ?? []).toList()
      ..removeWhere((todo) => todo.todoId == id);

    _todosController.add(todos);
  }

  dipose() {
    _todosController.close();
  }
}

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {

  TodosBloc _bloc;

  removeTodo(Todo todo) async {
    final confirmed = await showDialog(context: context, builder: (context) {
        return ConfirmDialog;

    });

    if (confirmed != true) {
      return;
    }

    _bloc.removeTodo(todo.todoId);

  }

  initState() {
    super.initState();
    _bloc = new TodosBloc(repository)..loadTodos();
  }


  @override
  void dispose() {
    _bloc.dipose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: _bloc.todos$,
      builder: (_, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final todos = snapshot.data;

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (_, index) {
            if (index >= todos.length) return null;

            return GestureDetector(
              onTap: () => removeTodo(todos[index]),
              child: Text("Todo ${todos[index].title}")
              );
          
          },
        );
      }
    );
  }
}*/
