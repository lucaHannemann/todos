import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:Todo/timer_bloc.dart';

// ignore: must_be_immutable
class StopwatchTodo extends StatefulWidget {
  String id;
  String timeSpent;
  int timeInMilliseconds;
  bool isTrackingTime;
  Function(bool) trackCallback;
  Function(String) timeCallback;

  StopwatchTodo(
      {this.id,
      this.timeInMilliseconds,
      this.isTrackingTime,
      this.timeSpent,
      this.trackCallback,
      this.timeCallback});
  @override
  _StopwatchTodoState createState() => _StopwatchTodoState();
}

class _StopwatchTodoState extends State<StopwatchTodo> {
  var time;
  final dbRef = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser.uid;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: timeBloc.trackedTime,
      initialData: 0,
      builder: (context, snapshot) {
        final value = snapshot.data + widget.timeInMilliseconds;
        final displayTime = StopWatchTimer.getDisplayTime(value);
        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.height * 0.2,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all()),
              child: Text(
                displayTime.substring(0, 8),
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Container(
                width: MediaQuery.of(context).size.height * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: () {
                        setState(() {
                          timeBloc.startTracking();
                        });
                      },
                      backgroundColor: Colors.green,
                      child: Text("Start"),
                    ),
                    FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: () {
                        timeBloc.stopTracking(displayTime,
                            snapshot.data, widget.id, currentUser);
                      },
                      backgroundColor: Colors.red,
                      child: Text("Stop"),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
