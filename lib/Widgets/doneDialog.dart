import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoneDialog extends StatefulWidget {
  final data;

  const DoneDialog({Key key, this.data}) : super(key: key);

  @override
  _DoneDialogState createState() => _DoneDialogState();
}

class _DoneDialogState extends State<DoneDialog> {
  String currentTime = DateFormat("dd.MM.yyyy " "HH:mm").format(DateTime.now());
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  String id;
  String title;
  String description;
  String timeSpent;
  String color;
  String dueDate;
  String fontcolor;
  int timeInMilliseconds;

  void finishTodo(
      String todoId,
      String dueDate,
      String title,
      String description,
      String color,
      String timeSpent,
      int timeInMilliseconds,
      String user,
      String fontcolor) {
    FirebaseFirestore.instance
        .collection("user")
        .doc(user)
        .collection("doneTodos")
        .doc(todoId)
        .set({
      "title": title,
      "description": description,
      "color": color,
      "doneDate": currentTime,
      "dueDate": dueDate,
      "timeSpent": timeSpent,
      "timeInMilliseconds": timeInMilliseconds,
      "timestamp": DateTime.now(),
      "textcolor": fontcolor
    });
    FirebaseFirestore.instance
        .collection("user")
        .doc(user)
        .collection("todos")
        .doc(todoId)
        .delete();
  }

  @override
  void initState() {
    super.initState();
    id = widget.data.id;
    title = widget.data["title"];
    description = widget.data["description"];
    timeSpent = widget.data["timeSpent"];
    color = widget.data["color"];
    dueDate = widget.data["dueDate"];
    fontcolor = widget.data["textcolor"];
    timeInMilliseconds = widget.data["timeInMilliseconds"];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(8),
      content: Text("Do you really want to finish this Task?",
          style: TextStyle(fontSize: 20)),
      actions: [
        FlatButton(
            onPressed: () {
              finishTodo(id, dueDate, title, description, color, timeSpent,
                  timeInMilliseconds, currentUser, fontcolor);
              Navigator.pop(context, true);
            },
            child: Text(
              "Yes",
              style: TextStyle(fontSize: 20),
            )),
        FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              "No",
              style: TextStyle(fontSize: 20),
            ))
      ],
    );
  }
}
