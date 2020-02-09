import 'package:flutter/material.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:quiver/async.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class CntdTimer extends StatefulWidget {
  QuestionService store;
  CntdTimer({this.store});
  @override
  _CntdTimerState createState() => _CntdTimerState();
}

class _CntdTimerState extends State<CntdTimer> {
  int _start = 120;
  int _current = 120;
  var _sub;
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  final ReactiveModel<QuestionService> questionModelRM =
      Injector.getAsReactive<QuestionService>();
  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    this._sub = countDownTimer.listen(null);
    this._sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
        widget.store.remainingTime = _current;
        print(_current);
      });
    });

    this._sub.onDone(() {
      print("Done");
      this._sub.cancel();
      questionModelRM.setState((state) {
        widget.store.remainingTime = _current;
        widget.store.toggleDragCompleted(true);
      });
    });
  }

  @override
  void dispose() {
    this._sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  startTimer();
    return Text("$_current");
  }
}
