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
                  colors: [Colors.teal[500], Colors.purple[900]]),
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
      Offset(media.width / 8, media.height / 7),
      Offset(media.width * (13 / 24), media.height / 7),
      Offset(media.width / 8, media.height * 6 / 7 - media.width / 3),
      Offset(media.width * (13 / 24), media.height * 6 / 7 - media.width / 3)
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
                      Offset(media.width / 2 - media.width * .18,
                          media.height / 2 - media.width * .18),
                      store.questions[_index].question),
                  Stack(
                    children: <Widget>[
                      _buildDragTargetWithData(
                          store.questions[_index].answers[0].isCorrect,
                          store.questions[_index].answers[0].answer,
                          ofsetlist[0]),
                      _buildDragTargetWithData(
                          store.questions[_index].answers[1].isCorrect,
                          store.questions[_index].answers[1].answer,
                          ofsetlist[1]),
                      _buildDragTargetWithData(
                          store.questions[_index].answers[2].isCorrect,
                          store.questions[_index].answers[2].answer,
                          ofsetlist[2]),
                      _buildDragTargetWithData(
                          store.questions[_index].answers[3].isCorrect,
                          store.questions[_index].answers[3].answer,
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
                      if (_index >= 2) {
                        _showDialog(context);
                        // Navigator.pop(context);
                      } else {
                        _index++;
                      }
                    });
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildDraggable(Offset ofset, String text) {
    Size media = MediaQuery.of(context).size;
    return Positioned(
      top: ofset.dy,
      left: ofset.dx,
      child: Draggable(
        child: buildCircledBox(text, media.width * .36, color: Colors.black12),
        feedback:
            buildCircledBox(text, media.width * .36, color: Colors.transparent),
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

  Widget _buildDragTargetWithData(bool isAnswer, String text, Offset ofset) {
    Size media = MediaQuery.of(context).size;
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
          return buildCircledBox(text, media.width / 3, color: Colors.black12);
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

  Container buildCircledBox(String title, double size, {Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: color,
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(inherit: false, fontSize: 20),
        ),
      ),
    );
  }

  void _showDialog(BuildContext ctx) {
    // showGeneralDialog(
    //     context: ctx,
    //     barrierDismissible: true,
    //     barrierLabel:
    //         MaterialLocalizations.of(context).modalBarrierDismissLabel,
    //     barrierColor: Colors.black45,
    //     transitionDuration: const Duration(milliseconds: 600),
    //     pageBuilder: (BuildContext buildContext, Animation animation,
    //         Animation secondaryAnimation) {
    //       return Center(
    //         child: Container(
    //           width: MediaQuery.of(context).size.width * .8,
    //           height: MediaQuery.of(context).size.height * .8,
    //           padding: EdgeInsets.all(20),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(10),
    //             color: Colors.pink[200],
    //           ),
    //           child: Column(
    //             children: [
    //               RaisedButton(
    //                 onPressed: () {
    //                   // Navigator.popUntil(context, predicate); ile home gidilebilir
    //                   // Navigator.of(context).pop();
    //                 },
    //                 child: Text(
    //                   "Save",
    //                   style: TextStyle(color: Colors.white),
    //                 ),
    //                 color: const Color(0xFF1BC0C5),
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     });
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What do you want to remember?'),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
