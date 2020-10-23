import 'package:Todo/Widgets/drawer.dart';
import 'package:Todo/Widgets/todos.dart';
import 'package:Todo/testwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'model/todo.dart';

import 'Widgets/createTodo.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  bool isCreatingNewTodo = false;
  var currentUser = FirebaseAuth.instance.currentUser.uid;

  showCreateDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return CreateTodo();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Todo Manager"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    onPressed: () {
                      setState(
                        () {
                          showCreateDialog(context);
                        },
                      );
                    },
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                ],
              ),
              //Todos(),
              Testwidget(),
            ],
          ),
        ),
      ),
    );
  }
}
