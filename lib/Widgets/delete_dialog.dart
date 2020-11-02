import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../todos_bloc.dart';

class DeleteDialog extends StatefulWidget {
  final data;
  DeleteDialog({this.data});

  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  var currentUser = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(8),
      content: Text("Do you really want to delete this Task?",
          style: TextStyle(fontSize: 18)),
      actions: [
        FlatButton(
            onPressed: () {
              todoBloc.deleteTodo(widget.data, currentUser, context);
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
            )),
      ],
    );
  }
}
