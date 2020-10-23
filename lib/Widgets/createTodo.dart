import 'package:Todo/Widgets/colorpicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CreateTodo extends StatefulWidget {
  @override
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final dbRef = FirebaseFirestore.instance;

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  Color currentColor;
  DateTime now;
  String day;
  String time;
  String date;

  final _formkey = GlobalKey<FormState>();

  String user = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    currentColor = Color(0xff5cb6e3);
    now = DateTime.now();
    day = DateFormat("dd.MM.yyyy").format(now);
    time = DateFormat.Hm().format(now);
    date = DateFormat("dd.MM.yyyy " "HH:mm").format(now);
  }

  void updateColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  void setData(String title, String description, String color, String date,
      DateTime timestamp, String userId, String textColor) {
    dbRef.collection("user").doc(userId).collection("todos").add({
      "title": title,
      "description": description,
      "color": color.substring(6, 16),
      "dueDate": date,
      "timeSpent": "00:00:00",
      "timeInMilliseconds": 0,
      "timestamp": timestamp,
      "textcolor": textColor
    });
  }

  String setTextcolor(Color todoColor) {
    if (todoColor.computeLuminance() > 0.5) {
      return Colors.black.toString();
    } else {
      return Colors.white.toString();
    }
  }

  String validateTextinput(String value, String nameOfInput) {
    value = value.trim();
    if (value.isEmpty || value == null) {
      return "enter a " + nameOfInput;
    }
    if (value.length > 200) {
      return nameOfInput + " is too long";
    }
    return null;
  }

  void setNewColor(context, Color currentColor) async {
    Color newColor = await showDialog(
        barrierDismissible: false,
        context: context,
        child: ColorpickerDialog(
          defaultColor: currentColor,
        ));
    updateColor(newColor);
  }

  void updateTime(DateTime setter) {
    setState(() {
      day = DateFormat("dd.MM.yyyy").format(setter);
      time = DateFormat.Hm().format(setter);
      date = DateFormat("dd.MM.yyyy" " HH:mm").format(setter);
    });
  }

  void createToto(context, GlobalKey<FormState> formkey, Color currentColor, String title,
      String description, date, DateTime now, String user) {
    if (formkey.currentState.validate()) {
      String fontcolor = setTextcolor(currentColor).substring(6, 16);
      setData(title, description, currentColor.toString(), date.toString(), now,
          user, fontcolor);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formkey,
        child: AlertDialog(
          titlePadding: EdgeInsets.all(0),
          title: Container(
            padding: EdgeInsets.all(10),
            color: Colors.blue,
            child: Text(
              "Create a new Todo",
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validator: (value) {
                      return validateTextinput(value, "Title");
                    },
                    controller: titlecontroller,
                    decoration: InputDecoration(
                      labelText: "Title",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: TextFormField(
                      validator: (value) {
                        return validateTextinput(value, "Description");
                      },
                      controller: descriptioncontroller,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        FlatButton(
                          onPressed: () {
                            setNewColor(context, currentColor);
                          },
                          child:
                              CircleColor(color: currentColor, circleSize: 45),
                        ),
                        Text("Pick a Color")
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        RaisedButton(
                          color: Colors.white,
                          onPressed: () {
                            DatePicker.showDateTimePicker(
                              context,
                              locale: LocaleType.de,
                              minTime: DateTime.now(),
                              onConfirm: (setTime) {
                                updateTime(setTime);
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Text(day, style: TextStyle(fontSize: 15)),
                              Text(
                                time,
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        Text("Pick a Duedate")
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40, bottom: 20),
                    child: RaisedButton(
                      onPressed: () {
                        createToto(
                            context,
                            _formkey,
                            currentColor,
                            titlecontroller.text,
                            descriptioncontroller.text,
                            date,
                            now,
                            user);
                      },
                      child: Text("Create Now"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
