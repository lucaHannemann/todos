import 'package:Todo/Widgets/email_form.dart';
import 'package:Todo/widgets/overview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:validators/validators.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  int signInType;
  bool wantsToRegister = false;

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin facebookSignIn = new FacebookLogin();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void logInToFb() {
    firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
    .then((result) {
       setState(() {
        isLoading = true;
      });
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
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Text("Error by signing in")),
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

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
        setState(() {
        isLoading = true;
      });
    if (googleSignInAccount == null) {
      return;
    }
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    UserCredential authResult =
        await firebaseAuth.signInWithCredential(credential);
    var _user = authResult.user;
    User currentUser = firebaseAuth.currentUser;
    assert(_user.uid == currentUser.uid);
    if (googleSignInAccount != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Overview(),
          ));
    }
  }

  Future<UserCredential> initiateFacebookLogin() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
          setState(() {
            isLoading = true;
          });
        FacebookAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken.token);
        return await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential)
            .then((value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Overview()),
                ));
        break;
      case FacebookLoginStatus.cancelledByUser:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        break;
      default:
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wantsToRegister
          ? AppBar(
              leading: FlatButton(
                  onPressed: () {
                    setState(() {
                      wantsToRegister = false;
                    });
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              title: Text("Todo Manager"),
            )
          : AppBar(
              leading: Container(),
              title: Text("Todo Manager"),
            ),
      body: wantsToRegister
          ? EmailForm()
          : Center(
              child: isLoading ? CircularProgressIndicator() : Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.57,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.01),
                        child: TextFormField(
                          validator: (value) {
                            value = value.trim();
                            if (value.isEmpty || value == null) {
                              return "Enter an email";
                            }
                            if (!isEmail(value)) {
                              return "enter a valid email";
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: InputDecoration(labelText: "Email"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.01),
                        child: TextFormField(
                          validator: (value) {
                            value = value.trim();
                            if (value.isEmpty || value == null) {
                              return "enter a password";
                            }
                            return null;
                          },
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(labelText: "Password"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.01),
                        child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                logInToFb();
                              }
                            },
                            child: Text("Sign in")),
                      ),
                      SignInButton(Buttons.Google, text: "Sign in with Google",
                          onPressed: () async {
                        await signInWithGoogle();
                      }),
                      SignInButton(Buttons.Facebook,
                          text: "Sign in with Facebook", onPressed: () async {
                        await initiateFacebookLogin();
                      }),
                      Container(
                        width: double.infinity,
                        child: Padding(
                            padding: EdgeInsets.all(1),
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  signInType = 1;
                                  wantsToRegister = true;
                                });
                              },
                              hoverColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black)),
                              child: Text("Sign up with Email"),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
