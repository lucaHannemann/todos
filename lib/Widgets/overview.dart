import 'package:Todo/Widgets/login.dart';
import 'package:Todo/Widgets/todos.dart';
import 'package:Todo/app_bloc.dart';
import 'package:Todo/done_todos.dart';
import 'package:Todo/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'create_todo.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  bool isCreatingNewTodo = false;
  String currentUser = FirebaseAuth.instance.currentUser.uid;

  showCreateDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return CreateTodo();
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Text(""),
          title: Text("Todo Manager"),
          actions: [
            FlatButton(
              onPressed: () {
                appBloc.logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ));
              },
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.list),
              ),
              Tab(
                icon: Icon(Icons.check),
              )
            ],
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.83,
                    child: TabBarView(
                      children: [Todos(), DoneTodos()],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 60, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    autofocus: true,
                    onPressed: () {
                      setState(
                        () {
                          showDialog(
                            context: context,
                            builder: (context) => CreateTodo(),
                          );
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
            ),
          ],
        ),
      ),
    );
  }
}
