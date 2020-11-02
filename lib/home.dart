import 'package:Todo/Widgets/email_form.dart';
import 'package:Todo/widgets/login.dart';
import 'package:Todo/widgets/overview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_bloc.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int signInType;
  bool wantsToRegister = false;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      appBloc.isLoggedIn = true;
    } else {
      appBloc.isLoggedIn = false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return appBloc.isLoggedIn ? Overview() : Login();
  }
}
