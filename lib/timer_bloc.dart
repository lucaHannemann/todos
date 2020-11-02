import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";
import 'package:rxdart/rxdart.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerBloc {
  Stream<int> trackedTime = PublishSubject();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  void setTimeToFb(milliseconds, displaytime, id, user) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(user)
        .collection("todos")
        .doc(id)
        .update({"timeInMilliseconds": milliseconds, "timeSpent": displaytime});
  }

  void startTracking() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    trackedTime = _stopWatchTimer.rawTime;
  }

  void stopTracking(displayTime, timeInMilliseconds, todoId, userId) {
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    setTimeToFb(timeInMilliseconds, displayTime.substring(0,8), todoId, userId);
  }
  
}

final timeBloc = TimerBloc();
