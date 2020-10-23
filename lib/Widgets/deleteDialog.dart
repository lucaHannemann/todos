import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatefulWidget {
  final id;
  DeleteDialog({this.id});

  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  var currentUser = FirebaseAuth.instance.currentUser.uid;

  void deleteTodo(String id, String user) {
    FirebaseFirestore.instance
        .collection("user")
        .doc(user)
        .collection("todos")
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(8),
      content: Text("Do you really want to delete this Task?", style: TextStyle(fontSize: 18)),
      actions: [
        FlatButton(
            onPressed: () {
              setState(() {
                deleteTodo(widget.id, currentUser);
              });
              Navigator.pop(context, true);
            },
            child: Text("Yes", style: TextStyle(fontSize: 20),)
        ),
        FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("No", style: TextStyle(fontSize: 20),)
        ),
      ],
    );
  }
}
