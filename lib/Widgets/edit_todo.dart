import 'package:Todo/Widgets/colorpicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:Todo/todos_bloc.dart';

class EditTodo extends StatefulWidget {
  final String title;
  final String description;
  final int color;
  final String dueDate;
  final String id;
  EditTodo({this.title, this.description, this.color, this.dueDate, this.id});

  @override
  _EditTodoState createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  Color currentColor;
  String dueDate;
  String day;
  String time;
  String id;
  var date;
  var currentUser = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    titlecontroller = TextEditingController(text: widget.title);
    descriptioncontroller = TextEditingController(text: widget.description);
    currentColor = Color(widget.color);
    dueDate = widget.dueDate;
    day = widget.dueDate.substring(0, 10);
    time = widget.dueDate.substring(11, 16);
    id = widget.id;
    date = widget.dueDate;
  }

  void updateColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  String validateTextinput(value, String nameOfInput) {
    value = value.trim();
    if (value.isEmpty || value == null) {
      return "enter a " + nameOfInput;
    }
    if (value.length > 200) {
      return nameOfInput + " is too long";
    }
    return null;
  }

  void setNewColor(context, currentColor) async {
    Color newColor = await showDialog(
        barrierDismissible: false,
        context: context,
        child: ColorpickerDialog(
          defaultColor: currentColor,
        ));
    updateColor(newColor);
  }

  void updateTime(setter) {
    setState(() {
      day = DateFormat("dd.MM.yyyy").format(setter);
      time = DateFormat.Hm().format(setter);
      date = DateFormat("dd.MM.yyyy" " HH:mm").format(setter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: AlertDialog(
        title: Text("Edit your Todo"),
        content: SingleChildScrollView(
          child: Container(
            height: 425,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    return validateTextinput(value, "Title");
                  },
                  decoration: InputDecoration(labelText: "Title"),
                  controller: titlecontroller,
                ),
                TextFormField(
                  validator: (value) {
                    value = value.trim();
                    return validateTextinput(value, "Description");
                  },
                  decoration: InputDecoration(labelText: "Description"),
                  controller: descriptioncontroller,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: FlatButton(
                    onPressed: () {
                      setNewColor(context, currentColor);
                    },
                    child: CircleColor(color: currentColor, circleSize: 45),
                  ),
                ),
                Text("Update your color"),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: RaisedButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        minTime: DateTime.now(),
                        onConfirm: (setTime) {
                          setState(() {
                            updateTime(setTime);
                          });
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
                ),
                Text("Update your duedate"),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        todoBloc.updateTodo(
                            context,
                            currentUser,
                            id,
                            date,
                            titlecontroller.text,
                            descriptioncontroller.text,
                            currentColor);
                      }
                    },
                    child: Text("Update your Todo"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
