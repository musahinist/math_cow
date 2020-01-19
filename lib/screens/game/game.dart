import 'dart:math';

import 'package:flutter/material.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:math_cow/components/app_bar.dart';
import 'package:math_cow/components/progress_indicator.dart';

import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/screens/home/home.dart';
import 'package:math_cow/utils/draw_svg.dart';

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
  final String rawSvg =
      '''<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="100px" height="100px" viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve">
<text transform="matrix(1 0 0 1 39.5254 62.5)" fill="#FFFFFF" font-family="RobotoMono" font-size="36">0</text>
</svg>''';
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
                    SVG(store.questions[_index].question),
                    //SVG(rawSvg)
                    // store.questions[_index].question
                  ),
                  Stack(
                    children: <Widget>[
                      _buildDragTargetWithData(
                          store.questions[_index].answers[0].isCorrect,
                          SVG(store.questions[_index].answers[0].answer),
                          // SVG(rawSvg),
                          // store.questions[_index].answers[0].answer,
                          ofsetlist[0]),
                      _buildDragTargetWithData(
                          store.questions[_index].answers[1].isCorrect,
                          SVG(store.questions[_index].answers[1].answer),
                          //SVG(rawSvg),
                          // store.questions[_index].answers[1].answer,
                          ofsetlist[1]),
                      _buildDragTargetWithData(
                          store.questions[_index].answers[2].isCorrect,
                          SVG(store.questions[_index].answers[2].answer),
                          //SVG(rawSvg),
                          //store.questions[_index].answers[2].answer,
                          ofsetlist[2]),
                      _buildDragTargetWithData(
                          store.questions[_index].answers[3].isCorrect,
                          SVG(store.questions[_index].answers[3].answer),
                          // SVG(rawSvg),
                          //store.questions[_index].answers[3].answer,
                          ofsetlist[3]),
                    ],
                  ),
                  // Positioned(
                  //     bottom: 60,
                  //     right: media.width / 2 - 30,
                  //     child: Container(
                  //       width: 60,
                  //       height: 60,
                  //       child: FlareActor(
                  //         "animations/timer.flr",
                  //         alignment: Alignment.center,
                  //         fit: BoxFit.contain,
                  //         sizeFromArtboard: true,
                  //         animation: "playBw",
                  //         callback: (a) {
                  //           setState(() {
                  //             // _isDragCompleted = false;
                  //             // _isAnswerCorrect = false;
                  //             // if (_index >= 1) {
                  //             //   _showDialog(store);
                  //             //   // Navigator.pop(context);
                  //             // } else {
                  //             //   _index++;
                  //             // }
                  //           });
                  //         },
                  //       ),
                  //     )),
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
                  _isAnswerCorrect
                      ? "animations/success.flr"
                      : "animations/fail.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  sizeFromArtboard: true,
                  animation: "patlama",
                  callback: (a) {
                    setState(() {
                      _isDragCompleted = false;
                      _isAnswerCorrect = false;
                      _index++;
                      if (_index + 1 >= store.questions.length) {
                        _showDialog(store);
                        // Navigator.pop(context);
                      } else {}
                    });
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildDraggable(Offset ofset, SVG svg) {
    Size media = MediaQuery.of(context).size;
    return Positioned(
      top: ofset.dy,
      left: ofset.dx,
      child: Draggable(
        child: buildCircledBox(svg, media.width * .36, color: Colors.black12),
        feedback:
            buildCircledBox(svg, media.width * .36, color: Colors.transparent),
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

  Widget _buildDragTargetWithData(bool isAnswer, SVG svg, Offset ofset) {
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
          return buildCircledBox(svg, media.width / 3, color: Colors.black12);
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

  Container buildCircledBox(SVG svg, double size, {Color color}) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: color,
        ),
        child: svg);
  }

  void _showDialog(QuestionService qs) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .6,
              height: MediaQuery.of(context).size.height * .5,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.purple[900],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 250,
                    height: 200,
                    child: FlareActor(
                      "animations/congrats.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      sizeFromArtboard: true,
                      animation: "Untitled",
                      callback: (a) {
                        setState(() {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/app', ModalRoute.withName("/app"));
                          //  Navigator.pop(context);
                          // Navigator.of(context).pushReplacementNamed('/app');
                        });
                      },
                    ),
                  ),
                  // Text(
                  //   "You Just Finished a Card",
                  //   style: TextStyle(fontSize: 16, inherit: false),
                  // ),
                  Text(
                    "Congrats",
                    style: TextStyle(fontSize: 20, inherit: false),
                  ),
                  // RaisedButton(
                  //   onPressed: () {
                  //     // Navigator.popUntil(context, predicate); ile home gidilebilir
                  //     Navigator.popUntil(
                  //         context, ModalRoute.withName('/second'));
                  //     //Navigator.of(context).pop();
                  //   },
                  //   child: Text(
                  //     "Back to the Cards",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   color: const Color(0xFF1BC0C5),
                  // )
                ],
              ),
            ),
          );
        });
    // flutter defined function
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         backgroundColor: Colors.white,
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(20.0)), //this right here
    //         child: Container(
    //           height: 200,
    //           child: Padding(
    //             padding: const EdgeInsets.all(12.0),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 TextField(
    //                   decoration: InputDecoration(
    //                       border: InputBorder.none,
    //                       hintText: 'What do you want to remember?'),
    //                 ),
    //                 SizedBox(
    //                   width: 320.0,
    //                   child: RaisedButton(
    //                     onPressed: () {
    //                       Navigator.of(context).pop();
    //                     },
    //                     child: Text(
    //                       "Save",
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                     color: const Color(0xFF1BC0C5),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }
}
