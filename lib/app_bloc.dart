import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppBloc {
  bool isLoggedIn;

  void logout() {
    FirebaseAuth.instance.signOut();
    FacebookLogin().logOut();
    GoogleSignIn().signOut();
  }
}

final appBloc = AppBloc();
