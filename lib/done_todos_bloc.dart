import 'package:Todo/done_todos.dart';
import 'package:Todo/resources/doneTodoRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'model/doneTodo.dart';

class DoneTodosBloc {
  final _repository = DoneTodoRepository();
  final _doneTodofetcher = PublishSubject<DoneTodo>();

  Stream<DoneTodo> get allDoneTodos => _doneTodofetcher.stream;

  fetchAllDoneTodos() async {
    DoneTodo doneTodo = await _repository.fetchAllDoneTodos();
    _doneTodofetcher.sink.add(doneTodo);
  }

  dispose() {
    _doneTodofetcher.close();
  }

  setBackTodo(
    BuildContext context,
    String todoId,
    String currentUser,
    int color,
    String description,
    String dueDate,
    int timeInMilliseconds,
    String timeSpent,
    Timestamp timestamp,
    String title,
    int textcolor,
  ) {
    FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser)
        .collection("todos")
        .doc(todoId)
        .set({
      "color": color,
      "description": description,
      "dueDate": dueDate,
      "timeInMilliseconds": timeInMilliseconds,
      "timeSpent": timeSpent,
      "timestamp": timestamp,
      "title": title,
      "textcolor": textcolor
    });
    FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser)
        .collection("doneTodos")
        .doc(todoId)
        .delete();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DoneTodos(),
        ));
  }
}

final doneBloc = DoneTodosBloc();
