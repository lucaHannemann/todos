import 'package:Todo/Widgets/drawer.dart';
import 'package:Todo/Widgets/editTodo.dart';
import 'package:Todo/Widgets/stopwatch.dart';
import 'package:Todo/Widgets/timerNeedsToStop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleTodo extends StatefulWidget {
  final data;

  const SingleTodo({Key key, this.data}) : super(key: key);

  @override
  _SingleTodoState createState() => _SingleTodoState();
}

class _SingleTodoState extends State<SingleTodo> {
  bool isTrackingTime = false;
  String currentTime = DateFormat("dd.MM.yyyy" "HH:mm").format(DateTime.now());
  String user = FirebaseAuth.instance.currentUser.uid;
  String timeSpent;
  String id;
  String title;
  String description;
  String color;
  String dueDate;
  String textcolor;
  int timeInMilliseconds;

  @override
  void initState() {
    super.initState();
    timeSpent = widget.data["timeSpent"];
    id = widget.data.id;
    title = widget.data["title"];
    description = widget.data["description"];
    color = widget.data["color"];
    dueDate = widget.data["dueDate"];
    textcolor = widget.data["textcolor"];
    timeInMilliseconds = widget.data["timeInMilliseconds"];
  }

  trackCallback(bool trackfromChild) {
    setState(() {
      isTrackingTime = trackfromChild;
    });
  }

  timeCallback(String newTimeSpent) {
    setState(() {
      timeSpent = newTimeSpent;
    });
  }

  void finishTodo(
      bool isTrackingTime,
      String id,
      String title,
      String description,
      String color,
      String timeSpent,
      int timeInMilliseconds,
      String currentUser,
      String dueDate,
      String textcolor) {
    if (isTrackingTime) {
      showDialog(
        context: context,
        builder: (context) {
          return TimerNeedsToStop();
        },
      );
      return;
    }
    FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser)
        .collection("doneTodos")
        .doc(id)
        .set({
      "title": title,
      "description": description,
      "color": color,
      "doneDate": currentTime,
      "dueDate": dueDate,
      "timeSpent": timeSpent,
      "timeInMilliseconds": timeInMilliseconds,
      "timestamp": DateTime.now(),
      "textcolor": textcolor
    });
    FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser)
        .collection("todos")
        .doc(id)
        .delete();
    Navigator.pop(context);
  }

  showEditDialog(context, String id, String title, String description,
      String color, String dueDate) async {
    await showDialog(
      context: context,
      child: EditTodo(
        id: id,
        title: title,
        description: description,
        color: color,
        dueDate: dueDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.data.id;
    String title = widget.data["title"];
    String description = widget.data["description"];
    String color = widget.data["color"];
    String dueDate = widget.data["dueDate"];
    String textcolor = widget.data["textcolor"];
    int timeInMilliseconds = widget.data["timeInMilliseconds"];

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text("Todo Manager")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton.icon(
                  onPressed: () {
                    showEditDialog(
                        context, id, title, description, color, dueDate);
                  },
                  icon: Icon(Icons.edit),
                  label: Text("edit"))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (Text(description)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StopwatchTodo(
                    id: id,
                    timeInMilliseconds: timeInMilliseconds,
                    timeSpent: timeSpent,
                    isTrackingTime: false,
                    trackCallback: trackCallback,
                    timeCallback: timeCallback),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    finishTodo(
                        isTrackingTime,
                        id,
                        title,
                        description,
                        color,
                        timeSpent,
                        timeInMilliseconds,
                        user,
                        dueDate,
                        textcolor);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Finish Todo",
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
