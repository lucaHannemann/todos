import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../todos_bloc.dart';

class DoneDialog extends StatefulWidget {
  final data;

  const DoneDialog({Key key, this.data}) : super(key: key);

  @override
  _DoneDialogState createState() => _DoneDialogState();
}

class _DoneDialogState extends State<DoneDialog> {
  String currentTime = DateFormat("dd.MM.yyyy " "HH:mm").format(DateTime.now());
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  var data;
  bool isTrackingTime = false;
  
  @override
  void initState() {
    super.initState();
    data = widget.data;
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
              todoBloc.finishTodo(
                data, currentUser, currentTime, isTrackingTime, context);            
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
