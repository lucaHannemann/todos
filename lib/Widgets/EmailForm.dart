import 'package:Todo/overview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class EmailForm extends StatefulWidget {
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void registerToFb() {
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Overview()),
      );
    }).catchError((err) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            title: Container(
              color: Colors.red,
              padding: EdgeInsets.all(10),
              child: Text("Error"),
            ),
            content: Text(err.message),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          );
        },
      );
    });
  }

  String validate(value, String type) {
    value = value.trim();
    switch (type) {
      case "email":
        if (value.isEmpty) {
          return 'Enter your email';
        }
        if (!isEmail(value)) {
          return "Enter a valid email";
        }
        return null;
        break;
      case "password":
        if (value.isEmpty) {
          return 'Enter your Password';
        }
        return null;
      default:
        return null;
    }
  }

  void signUp() {
    if (_formKey.currentState.validate()) {
      if (passwordController.text != confirmPasswordcontroller.text) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              titlePadding: EdgeInsets.all(0),
              title: Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Text("Error"),
              ),
              content: Text("Passwords don't match"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            );
          },
        );
        return null;
      }
      registerToFb();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(border: Border.all()),
          width: MediaQuery.of(context).size.width * 0.70,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  validator: (value) {
                    return validate(value, "email");
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  validator: (value) {
                    return validate(value, "password");
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2),
                child: TextFormField(
                  obscureText: true,
                  controller: confirmPasswordcontroller,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                  ),
                  validator: (value) {
                    return validate(value, "password");
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: RaisedButton(
                  onPressed: () {
                    signUp();
                  },
                  child: Text("Sign up now"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
