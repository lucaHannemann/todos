import 'package:Todo/Widgets/drawer.dart';
import 'package:Todo/Widgets/undo_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'done_todos_bloc.dart';

class DoneTodos extends StatefulWidget {
  @override
  _DoneTodosState createState() => _DoneTodosState();
}

class _DoneTodosState extends State<DoneTodos> {
  String currentUser = FirebaseAuth.instance.currentUser.uid;

  var snapData;
  int todocolor;
  int fontcolor;
  String title;
  String timeSpent;
  String doneDate;
  String id;
  String dueDate;
 
  void fillData(data) {
    snapData = data;
    id = data.id;
    fontcolor = data.textcolor;
    todocolor = data.color;
    title = data.title;
    timeSpent = data.timeSpent;
    doneDate = data.doneDate;
  }

  @override
  Widget build(BuildContext context) {
    doneBloc.fetchAllDoneTodos();
    return Scaffold(
      drawer: AppDrawer(),
      body: StreamBuilder(
        stream: doneBloc.allDoneTodos,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.data.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No finished Tasks ",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.only(top: 25),
              height: MediaQuery.of(context).size.height * 0.85,
              child: ListView.builder(
                itemCount: snapshot.data.data.length,
                itemBuilder: (context, int index) {
                  fillData(snapshot.data.data[index]);
                  return SizedBox(
                    height: 100,
                    width: 400,
                    child: Card(
                      color: Color(todocolor),
                      child: Dismissible(
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: Colors.green,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.add),
                                Text("Pick up Todo again")
                              ],
                            ),
                          ),
                        ),
                        key: Key(snapshot.data.data[index].id),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            return await showDialog(
                                context: context,
                                child: UndoDialog(
                                    data: snapshot.data.data[index]));
                          }
                          return false;
                        },
                        child: ListTile(
                          title: Text(
                            title,
                            style: TextStyle(color: Color(fontcolor)),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 9),
                                child: Text("The Task was done on: " + doneDate,
                                    style: TextStyle(color: Color(fontcolor))),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 9),
                                child: Text(
                                    "The time spent on the Todo was: " +
                                        timeSpent,
                                    style: TextStyle(color: Color(fontcolor))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
