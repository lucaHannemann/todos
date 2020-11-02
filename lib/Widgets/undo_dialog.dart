import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import '../done_todos_bloc.dart';

class UndoDialog extends StatefulWidget {
  final data;

  const UndoDialog({Key key, this.data}) : super(key: key);

  @override
  _UndoDialogState createState() => _UndoDialogState();
}

class _UndoDialogState extends State<UndoDialog> {
  var currentUser = FirebaseAuth.instance.currentUser.uid;
  DateTime now;
  String day;
  String time;
  String date;
  String id;
  int color;
  String description;
  int timeInMilliseconds;
  String timeSpent;
  Timestamp timestamp;
  String title;
  int textcolor;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    day = DateFormat("dd.MM.yyyy").format(now);
    time = DateFormat.Hm().format(now);
    date = DateFormat("dd.MM.yyyy hh:mm").format(now);
    id = widget.data.id;
    color = widget.data.color;
    description = widget.data.description;
    timeInMilliseconds = widget.data.timeInMilliseconds;
    timeSpent = widget.data.timeSpent;
    timestamp = widget.data.timestamp;
    title = widget.data.title;
    textcolor = widget.data.textcolor;
  }

  void updateTime(setter) {
    setState(() {
      day = DateFormat("dd.MM.yyyy").format(setter);
      time = DateFormat.Hm().format(setter);
      date = DateFormat("dd.MM.yyyy" " HH:mm").format(setter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.only(top: 15, right: 22, left: 22),
      title: Text("Set Todo back on List"),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.13,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        minTime: DateTime.now(),
                        onConfirm: (setTime) {
                          updateTime(setTime);
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Text(day, style: TextStyle(fontSize: 15)),
                        Text(
                          time,
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Text("Pick a new duedate")
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            doneBloc.setBackTodo(
                context,
                id,
                currentUser,
                color,
                description,
                date,
                timeInMilliseconds,
                timeSpent.substring(0, 8),
                timestamp,
                title,
                textcolor);
          },
          child: Text(
            "Confirm",
            style: TextStyle(fontSize: 20),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
