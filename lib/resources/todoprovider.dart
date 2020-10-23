import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/todo.dart';

class Todoprovider {
  Future<Todo> fetchTodoList() async {
    final currentUser = FirebaseAuth.instance.currentUser.uid;
    final todos = await FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser)
        .collection("todos")
        .get()
        .then((snapshot) {
      snapshot.docs.map((document) {
        return Todo.fromJson(document.data());
      }).toList();
    });
    return Todo.fromJson(todos);
  }
}
