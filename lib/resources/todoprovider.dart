import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/todo.dart';

class Todoprovider {
  Future<Todo> fetchTodoList() async {
    final currentUser = FirebaseAuth.instance.currentUser.uid;
    Map<String, dynamic> data = {};
    await FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser)
        .collection("todos")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((document) {
        snapshot.docs.map((document) {
          data.putIfAbsent(document.id, () => document.data());
        }).toList();
      });
    });
    return Todo.fromFirebase(data);
  }
}
