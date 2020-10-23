import 'package:Todo/Widgets/drawer.dart';
import 'package:Todo/Widgets/undoDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoneTodos extends StatefulWidget {
  @override
  _DoneTodosState createState() => _DoneTodosState();
}

class _DoneTodosState extends State<DoneTodos> {
  Stream<QuerySnapshot> _stream;

  var currentUser = FirebaseAuth.instance.currentUser.uid;

  var snapData;
  Color todocolor;
  int fontcolor;
  String title;
  String timeSpent;
  String doneDate;
  String id;
  String dueDate;
  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser)
        .collection("doneTodos")
        .orderBy("title")
        .snapshots();
  }

  void fillData(data) {
    snapData = data;
    fontcolor = int.parse(data["textcolor"]);
    todocolor = Color(int.parse(data["color"]));
    id = data.id;
    title = data["title"];
    timeSpent = data["timeSpent"];
    doneDate = data["doneDate"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Done Todos"),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.docs.length == 0) {
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
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, int index) {
                  fillData(snapshot.data.docs[index]);
                  var data = snapshot.data.docs[index];
                  Color todocolor = Color(int.parse(data["color"]));
                  Color fontcolor = Color(int.parse(data["textcolor"]));
                  String title = data["title"];
                  String timeSpent = data["timeSpent"];
                  String doneDate = data["doneDate"];

                  return SizedBox(
                    height: 100,
                    width: 400,
                    child: Card(
                      color: todocolor,
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
                        key: Key(snapshot.data.docs[index].id),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            return await showDialog(
                                context: context,
                                child: UndoDialog(
                                  data: snapshot.data.docs[index],
                                ));
                          }
                          return false;
                        },
                        child: ListTile(
                          title: Text(
                            title,
                            style: TextStyle(color: fontcolor),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 9),
                                child: Text("The Task was done on: " + doneDate,
                                    style: TextStyle(color: fontcolor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 9),
                                child: Text(
                                    "The time spent on the Todo was: " +
                                        timeSpent,
                                    style: TextStyle(color: fontcolor)),
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
