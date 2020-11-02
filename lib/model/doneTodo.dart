import 'package:cloud_firestore/cloud_firestore.dart';

class DoneTodo {
  List<_Data> _data = [];

  DoneTodo.fromFirebase(Map<String, dynamic> dataFromFirebase) {
    List<_Data> temp = [];
    for (var key in dataFromFirebase.keys) {
      _Data data = _Data(dataFromFirebase[key], key);
      temp.add(data);
    }
    _data = temp;
  }
  List<_Data> get data => _data;
}

class _Data {
  String _id;
  int _color;
  String _description;
  String _doneDate;
  String _dueDate;
  int _textcolor;
  int _timeInMilliseconds;
  String _timeSpent;
  Timestamp _timestamp;
  String _title;

  _Data(data, key) {
    _id = key;
    _color = data["color"];
    _description = data["description"];
    _doneDate = data["doneDate"];
    _dueDate = data["dueDate"];
    _textcolor = data["textcolor"];
    _timeInMilliseconds = data["timeInMilliseconds"];
    _timeSpent = data["timeSpent"];
    _timestamp = data["timestamp"];
    _title = data["title"];
  }

  String get id => _id;
  int get color => _color;
  String get description => _description;
  String get doneDate => _doneDate;
  String get dueDate => _dueDate;
  int get textcolor => _textcolor;
  int get timeInMilliseconds => _timeInMilliseconds;
  String get timeSpent => _timeSpent;
  Timestamp get timestamp => _timestamp;
  String get title => _title;
}
