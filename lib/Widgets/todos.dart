import 'package:Todo/Widgets/delete_dialog.dart';
import 'package:Todo/Widgets/done_dialog.dart';
import 'package:Todo/single_todo.dart';
import 'package:Todo/timer_bloc.dart';
import 'package:Todo/todos_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  String dbColor;
  String currentUser = FirebaseAuth.instance.currentUser.uid;

  int fontcolor;
  Color todocolor;
  String todoId;
  String title;
  String dueDate;
  String timeSpent;
  int timeInMilliseconds;
  var snapData;

  @override
  void initState() {
    super.initState();
  }

  void fillData(data) {
    snapData = data;
    todoId = data.id;
    fontcolor = data.textcolor;
    todocolor = Color(data.color);
    title = data.title;
    dueDate = data.dueDate;
    timeSpent = data.timeSpent;
    timeInMilliseconds = data.timeInMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    todoBloc.fetchAllTodos();
    return StreamBuilder(
      stream: todoBloc.allTodos,
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data.data.length == 0) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Press + to add new Todo",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.82,
              child: ListView.builder(
                itemCount: snapshot.data.data.length,
                itemBuilder: (context, int index) {
                  fillData(snapshot.data.data[index]);
                  return StreamBuilder(
                    stream: timeBloc.trackedTime,
                    initialData: 0,
                    builder: (context, snapshot2) {
                      final value = snapshot2.data + timeInMilliseconds;
                      final displayTime = StopWatchTimer.getDisplayTime(value);
                      return SizedBox(
                        height: 100,
                        width: 300,
                        child: Card(
                          color: todocolor,
                          child: Dismissible(
                            background: Container(
                              color: Colors.green,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check),
                                    Text("Finish Todo"),
                                  ],
                                ),
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    Text("Delete"),
                                  ],
                                ),
                              ),
                            ),
                            key: Key(index.toString()),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                return await showDialog(
                                    context: context,
                                    child: DoneDialog(
                                        data: snapshot.data.data[index]));
                              }
                              if (direction == DismissDirection.endToStart) {
                                return await showDialog(
                                    context: context,
                                    child: DeleteDialog(
                                        data: snapshot.data.data[index]));
                              }
                              return false;
                            },
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingleTodo(
                                          data: snapshot.data.data[index]),
                                    ));
                              },
                              title: Text(
                                title,
                                style: TextStyle(color: Color(fontcolor)),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 9),
                                    child: Text(
                                      "Duedate is: " + dueDate,
                                      style: TextStyle(color: Color(fontcolor)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 9),
                                    child: Text(
                                      "Already spent time is: " + displayTime,
                                      style: TextStyle(color: Color(fontcolor)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ));
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Press + to add new Todo",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
