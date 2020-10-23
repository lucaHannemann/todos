import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Firebase.initializeApp() == null) {
    await Firebase.initializeApp(
    name: "todo", 
    options: FirebaseOptions(
      appId: "1:110393881435:android:bf75e7bf2594d00845607e",
      apiKey: "AIzaSyB5zz8wTUdHXDnr6jgDM3OdxpFEer-18qs",
      messagingSenderId: "110393881435",
      projectId: "todos"
  ));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Manager',
      home: Home(),
    );
  }
}


