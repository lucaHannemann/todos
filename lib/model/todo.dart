import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  List<_Data> _data = [];

  Todo.fromFirebase(Map<String, dynamic> firebaseData) {
    List<_Data> temp = [];
    for (var key in firebaseData.keys) {
      _Data data = _Data(firebaseData[key], key);
      temp.add(data);
    }
    _data = temp;
  }
  List<_Data> get data => _data;
}

class _Data {
  String _id;
  int _color;
  String _descrption;
  String _dueDate;
  int _textcolor;
  int _timeInMilliseconds;
  String _timeSpent;
  Timestamp _timestamp;
  String _title;

  _Data(firebaseData, key) {
    _id = key;
    _color = firebaseData["color"];
    _descrption = firebaseData["description"];
    _dueDate = firebaseData["dueDate"];
    _textcolor = firebaseData["textcolor"];
    _timeInMilliseconds = firebaseData["timeInMilliseconds"];
    _timeSpent = firebaseData["timeSpent"];
    _timestamp = firebaseData["timestamp"];
    _title = firebaseData["title"];
  }
  String get id => _id;
  int get color => _color;
  String get description => _descrption;
  String get dueDate => _dueDate;
  int get textcolor => _textcolor;
  int get timeInMilliseconds => _timeInMilliseconds;
  String get timeSpent => _timeSpent;
  Timestamp get timestamp => _timestamp;
  String get title => _title;
}
