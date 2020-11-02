import 'package:Todo/Widgets/drawer.dart';
import 'package:Todo/Widgets/edit_todo.dart';
import 'package:Todo/Widgets/stopwatch.dart';
import 'package:Todo/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'todos_bloc.dart';

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
  int color;
  String dueDate;
  int textcolor;
  int timeInMilliseconds;

  @override
  void initState() {
    super.initState();
    timeSpent = widget.data.timeSpent;
    id = widget.data.id;
    title = widget.data.title;
    description = widget.data.description;
    color = widget.data.color;
    dueDate = widget.data.dueDate;
    textcolor = widget.data.textcolor;
    timeInMilliseconds = widget.data.timeInMilliseconds;
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

  showEditDialog(context, String id, String title, String description,
      int color, String dueDate) async {
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
    return Scaffold(
      appBar: new MyAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTodo(
                          title: title,
                          description: description,
                          color: color,
                          dueDate: dueDate,
                          id: id,
                        ),
                      );
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
                    timeCallback: timeCallback,
                  ),
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
                      todoBloc.finishTodo(widget.data, user, currentTime,
                          isTrackingTime, context);
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
      ),
    );
  }
}
