import 'dart:async';

import 'package:Todo/Widgets/deleteDialog.dart';
import 'package:Todo/Widgets/doneDialog.dart';
import 'package:Todo/singleTodo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  //List<Todo> todos = [];

  Stream<QuerySnapshot> _stream;
  String dbColor;
  var currentUser = FirebaseAuth.instance.currentUser.uid;

  int fontcolor;
  Color todocolor;
  String id;
  String title;
  String dueDate;
  String timeSpent;
  var snapData;
  /*loadItems() {
    FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser)
        .collection("todos")
        .orderBy("timestamp")
        .get()
        .then((result) {
      setState(() {
        todos = result.docs;
      });
    });
  }*/

  /*deleteTodo(String id) {
    // delete todo

    // remove todo from state
    setState(() {
      todos = todos.toList()..removeWhere((item) => item.id == id);
    });
  }*/

  @override
  void initState() {
    super.initState();

    //loadItems();

    _stream = FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser)
        .collection("todos")
        .orderBy("timestamp")
        .snapshots();
  }

  void fillData(data) {
    snapData = data;
    fontcolor = int.parse(data["textcolor"]);
    todocolor = Color(int.parse(data["color"]));
    id = data.id;
    title = data["title"];
    dueDate = data["dueDate"];
    timeSpent = data["timeSpent"];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data.docs.length == 0) {
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
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, int index) {
                fillData(snapshot.data.docs[index]);
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
                              context: context, child: DoneDialog(data: snapData));
                        }
                        if (direction == DismissDirection.endToStart) {
                          return await showDialog(
                              context: context,
                              child: DeleteDialog(
                                id: id,
                              ));
                        }
                        return false;
                      },
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SingleTodo(data: snapData),
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
                                "Already spent time is: " + timeSpent,
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
            ),
          );
        }
        return null;
      },
    );
  }
}
