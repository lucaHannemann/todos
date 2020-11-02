import 'package:Todo/Widgets/timer_needs_to_stop.dart';
import 'package:Todo/home.dart';
import 'package:Todo/model/todo.dart';
import 'package:Todo/widgets/overview.dart';
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

createTodo(
  context,
  GlobalKey<FormState> formkey,
  Color currentColor,
  String title,
  String description,
  DateTime now,
  date,
  String currentUser,
  Function setTextcolor,
) {
  if (formkey.currentState.validate()) {
    int fontcolor = int.parse(setTextcolor(currentColor).substring(6, 16));
    FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser)
        .collection("todos")
        .add({
      "title": title,
      "description": description,
      "color": int.parse(currentColor.toString().substring(6, 16)),
      "dueDate": date,
      "timeSpent": "00:00:00",
      "timeInMilliseconds": 0,
      "timestamp": now,
      "textcolor": fontcolor
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ));
  }
}

updateTodo(context, String currentUser, String docId, String dateInput,
    String title, String description, Color newColor) {
  FirebaseFirestore.instance
      .collection("user")
      .doc(currentUser)
      .collection("todos")
      .doc(docId)
      .update({
    "title": title,
    "description": description,
    "color": int.parse(newColor.toString().substring(6,16)),
    "dueDate": dateInput,
    "timestamp": DateTime.now()
  });
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ));
}

finishTodo(data, String currentUser, String currentTime, bool isTrackingTime,
    context) {
  if (isTrackingTime) {
    showDialog(
      context: context,
      builder: (context) {
        return TimerNeedsToStop();
      },
    );
    return;
  }
  deleteTodo(data, currentUser, context);
  setDoneTodo(currentUser, data, currentTime);
  
}

deleteTodo(data, String currentUser, context) {
  FirebaseFirestore.instance
      .collection("user")
      .doc(currentUser)
      .collection("todos")
      .doc(data.id)
      .delete();
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ));
}

setDoneTodo(String currentUser, data, String currentTime) {
  FirebaseFirestore.instance
      .collection("user")
      .doc(currentUser)
      .collection("doneTodos")
      .doc(data.id)
      .set({
    "title": data.title,
    "description": data.description,
    "color": data.color,
    "doneDate": currentTime,
    "dueDate": data.dueDate,
    "timeSpent": data.timeSpent,
    "timeInMilliseconds": data.timeInMilliseconds,
    "timestamp": DateTime.now(),
    "textcolor": data.textcolor
  });
}

}

final todoBloc = TodosBloc();
