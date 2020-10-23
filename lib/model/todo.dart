import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String _color;
  String _descrption;
  String _dueDate;
  String _textcolor;
  int _timeInMilliseconds;
  String _timeSpent;
  Timestamp _timestamp;
  String _title;
  
  Todo.fromJson(Map<String, dynamic> parsedJson) {
    _color = parsedJson["color"];
    _descrption = parsedJson["description"];
    _dueDate = parsedJson["dueDate"];
    _textcolor = parsedJson["textcolor"];
    _timeInMilliseconds = parsedJson["timeInMilliseconds"];
    _timeSpent = parsedJson["timeSpent"];
    _timestamp = parsedJson["timestamp"];
    _title = parsedJson["title"];
  }
  String get color => _color;
  String get description => _descrption;
  String get dueDate => _dueDate;
  String get textcolor => _textcolor;
  int get timeInMilliseconds => _timeInMilliseconds;
  String get timeSpent => _timeSpent;
  Timestamp get timestamp => _timestamp;
  String get title => _title;
}
