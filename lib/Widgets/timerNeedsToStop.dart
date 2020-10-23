import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TimerNeedsToStop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
        titlePadding: EdgeInsets.all(0),
        title: Container(
          padding: EdgeInsets.all(10),
          color: Colors.red,
          child: Text(
            "Timer needs to stop",
            style: TextStyle(color: Colors.white),
          ),
        ),
        content: Text(
            "The timer needs to be stopped to finish your Todo. Please press the Stop button"),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok", style: TextStyle(fontSize: 20),),
          )
        ],
      )),
    );
  }
}
