import 'package:Todo/doneTodos.dart';
import 'package:Todo/overview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home.dart';

class AppDrawer extends StatelessWidget {
  final String loginType;
  final facebookLogin = FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> logout() async {
    await facebookLogin.logOut();
    await _googleSignIn.signOut();
    await firebaseAuth.signOut();
  }

  AppDrawer({Key key, this.loginType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.10,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  "Navigation",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("Home"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Overview()));
            },
          ),
          Divider(),
          ListTile(
            title: Text("Done Todos"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DoneTodos()));
            },
          ),
          Divider(),
          ListTile(
            title: Text("Logout"),
            onTap: () {
              logout();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          )
        ],
      ),
    );
  }
}
