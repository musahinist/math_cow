import 'dart:math';

import 'package:flutter/material.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:math_cow/components/app_bar.dart';
import 'package:math_cow/components/progress_indicator.dart';

import 'package:math_cow/data/services/question_service..dart';

import 'package:math_cow/utils/loading_anim.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class GamePage extends StatefulWidget {
  final String id;
  const GamePage({Key key, @required this.id}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _isDragCompleted = false;
  bool _isAnswerCorrect = false;
  int _counter;
  int _index;
  // List<Question> qs;
  // QuestionApi qapi = QuestionApi();

  // void setCards() async {
  //   qs = await api.getQuestions(widget.id);
  // }

  @override
  void initState() {
    _counter = 0;
    _index = 0;
    // setCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.cyan[900], Colors.purple[900]]),
            ),
            child: StateBuilder<QuestionService>(
              models: [Injector.getAsReactive<QuestionService>()],
              builder: (contex, model) {
                return model.whenConnectionState(
                  onIdle: () => Text("idle"),
                  onWaiting: () => Center(child: Loading()),
                  onData: (store) => _gameStack(store),
                  onError: (_) => Text("error"),
                );
              },
            )));
  }

  Stack _gameStack(QuestionService store) {
    Size media = MediaQuery.of(context).size;
    List<Offset> ofsetlist = [
      Offset(40, 80),
      Offset(media.width - 160, 80),
      Offset(40, media.height - 200),
      Offset(media.width - 160, media.height - 200)
    ]..shuffle();
    return Stack(
      children: <Widget>[
        TransAppBar(
          licon: Icons.arrow_back,
          ctext: "QUESTIONS",
          rtext: "03:00",
          ricon: Icons.timelapse,
        ),
        _isDragCompleted == false
            ? Stack(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildDraggable(
                      Offset(media.width / 2 - 60, media.height / 2 - 60),
                      store.questions[_index].question),
                  Stack(
                    children: <Widget>[
                      _buildDragTargetWithData(
                          store.questions[_index].answers[0].isCorrect,
                          ofsetlist[0]),
                      _buildDragTargetWithData(
                          store.questions[_index].answers[1].isCorrect,
                          ofsetlist[1]),
                      _buildDragTargetWithData(
                          store.questions[_index].answers[2].isCorrect,
                          ofsetlist[2]),
                      _buildDragTargetWithData(
                          store.questions[_index].answers[3].isCorrect,
                          ofsetlist[3]),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: ProgressIndic(
                      percent: _counter,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              )
            : Center(
                child: FlareActor(
                  "animations/success.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  sizeFromArtboard: true,
                  color: _isAnswerCorrect ? null : Colors.red,
                  animation: "patlama",
                  callback: (a) {
                    setState(() {
                      _isDragCompleted = false;
                      _isAnswerCorrect = false;
                      _index++;
                      print("idex:$_index");
                    });
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildDraggable(Offset ofset, String text) {
    return Positioned(
      top: ofset.dy,
      left: ofset.dx,
      child: Draggable(
        child: buildCircledBox(text, color: Colors.green[200]),
        feedback: buildCircledBox(text, color: Colors.black),
        childWhenDragging:
            Container(), // buildCircledBox("+1", color:Colors.grey[300]),
        data: "Musa", //can be list etc.
        onDragStarted: () {},
        onDragCompleted: () {
          print("onDragCompleted");
        },
        onDragEnd: (details) {
          print("onDragEnd Accept = " + details.wasAccepted.toString());
          print("onDragEnd Velocity = " +
              details.velocity.pixelsPerSecond.distance.toString());
          print("onDragEnd Offeset= " + details.offset.direction.toString());
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          print("onDraggableCanceled " + velocity.toString());
        },
      ),
    );
  }

  Widget _buildDragTargetWithData(dynamic isAnswer, Offset ofset) {
    return Positioned(
      top: ofset.dy,
      left: ofset.dx,
      // right: 0.0,
      //  bottom: 0.0,
      child: DragTarget(
        builder: (BuildContext context, List<String> candidateData,
            List<dynamic> rejectedData) {
          print("candidateData = " +
              candidateData.toString() +
              " , rejectedData = " +
              rejectedData.toString());
          return buildCircledBox("$isAnswer",
              color: isAnswer ? Colors.green[200] : Colors.red[200]);
        },
        onWillAccept: (data) {
          print("onWillAccept and data:$data");
          return true; // return true or false. can use and/or
        },
        onAccept: (data) {
          setState(() {
            if (isAnswer) {
              _counter++;
              // _counter < 10 ? _counter++ : _counter = 0;
              _isAnswerCorrect = true;
            }
            _isDragCompleted = true;
          });

          print("onAccept and data:$data counter:$_counter");
        },
        onLeave: (data) {
          print("onLeave and data:$data");
        },
      ),
    );
  }

  Container buildCircledBox(String title, {Color color}) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        color: color.withAlpha(30),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(inherit: false, fontSize: 20),
        ),
      ),
    );
  }
}
