import 'package:flutter/material.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:math_cow/components/flipper.dart';
import 'package:math_cow/data/model/question.dart';
import 'package:math_cow/screens/game/drag-drop-game.dart';
import 'package:math_cow/screens/game/flip_game.dart';
import 'package:math_cow/screens/game/tinder-card.dart';

import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/components/app_bar.dart';
import 'package:math_cow/components/progress_indicator.dart';
import 'package:math_cow/utils/draw_svg.dart';
import 'package:math_cow/utils/loading_anim.dart';

class GamePage extends StatelessWidget {
  final String id;
  GamePage({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  resizeToAvoidBottomPadding: false,
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.teal[500], Colors.purple[900]]),
            ),
            child: StateBuilder<QuestionService>(
              models: [Injector.getAsReactive<QuestionService>()],
              builder: (context, model) {
                return model.whenConnectionState(
                  onIdle: () => Text("idle"),
                  onWaiting: () => Center(child: Loading()),
                  onData: (store) {
                    var questions = store.questions;
                    return _gameStack(context, store, questions);
                  }, //FlipGame(), //
                  onError: (_) => Text("error"),
                );
              },
            )));
  }

  Stack _gameStack(
      BuildContext context, QuestionService store, List<Question> questions) {
    final ReactiveModel<QuestionService> questionModelRM =
        Injector.getAsReactive<QuestionService>(context: context);
    // var questions = store.questions;
    // List shuffuleAnswer = [1, 2, 3, 4, 5]..shuffle();
    // Size media = MediaQuery.of(context).size;
    // List<Offset> ofsetlist = [
    //   Offset(0, media.height / 7),
    //   Offset(media.width / 2, media.height / 7),
    //   Offset(0, media.height * 6 / 7 - media.width / 3),
    //   Offset(media.width / 2, media.height * 6 / 7 - media.width / 3)
    // ]..shuffle();
    var gameList = [
      DragDropGame(
        store: store,
        questions: questions,
      ),
      TinderCard(questions: questions[0], store: store),
      //FlipGame()
    ]..shuffle();
    return Stack(
      //alignment: AlignmentDirectional.center,
      children: <Widget>[
        TransAppBar(
          licon: Icons.arrow_back,
          ctext: "CARD ${store.cardID}",
          rtext: "03:00",
          ricon: Icons.timelapse,
        ),
        store.isDragCompleted == false
            ? Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  gameList[0],
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: ProgressIndic(
                      cpercent: store.correctCounter,
                      wpercent: store.wrongCounter,
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
                  store.isAnswerCorrect
                      ? "animations/success.flr"
                      : "animations/fail.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  sizeFromArtboard: true,
                  animation: "patlama",
                  callback: (a) {
                    questionModelRM.setState(
                      (state) {
                        if (store.index + 1 < 10 && store.correctCounter < 5) {
                          store.indexIncrement();
                          store.toggleDragCompleted(false);
                          store.toggleAnswerCorrect(false);
                        } else if (store.correctCounter == 5) {
                          store.points;
                          store.addUserData();
                          return _showDialog(context, store);
                        } else {
                          store.points;
                          store.addUserData();
                          return _showDialog(context, store);
                        }
                      },
                    );
                  },
                ),
              ),
      ],
    );
  }

  void _showDialog(BuildContext context, QuestionService store) {
    // final ReactiveModel<QuestionService> questionModelRM =
    //     Injector.getAsReactive<QuestionService>(context: context);
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
                      store.correctCounter == 2
                          ? "animations/congrats.flr"
                          : "animations/fail.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      sizeFromArtboard: true,
                      animation:
                          store.correctCounter == 2 ? "Untitled" : "patlama",
                      callback: (a) {
                        // questionModelRM.setState((state) {
                        //   state.addUserData();
                        // });
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName('/'));
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     '/app', ModalRoute.withName("/app"));

                        // Navigator.pop(context);
                      },
                    ),
                  ),
                  // Text(
                  //   "You Just Finished a Card",
                  //   style: TextStyle(fontSize: 16, inherit: false),
                  // ),
                  Text(
                    store.correctCounter == 2 ? "Congrats" : "Try Again",
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
  // Widget _buildDraggable(BuildContext context, Offset ofset, SVG svg) {
  //   Size media = MediaQuery.of(context).size;
  //   return Draggable(
  //     maxSimultaneousDrags: 1,
  //     ignoringFeedbackSemantics: false,
  //     dragAnchor: DragAnchor.child,
  //     child: buildBox(svg, media.width, media.width / 3 /*media.width * .36*/
  //         ), //buildCircledBox(svg, media.width * .36, color: Colors.black12),
  //     feedback: buildBox(svg, media.width, media.width / 3 /*media.width * .36*/
  //         ),
  //     childWhenDragging:
  //         Container(), // buildCircledBox("+1", color:Colors.grey[300]),
  //     data: "Musa", //can be list etc.
  //     onDragStarted: () {},
  //     onDragCompleted: () {
  //       print("onDragCompleted");
  //     },
  //     onDragEnd: (details) {
  //       print("onDragEnd Accept = " + details.wasAccepted.toString());
  //       print("onDragEnd Velocity = " +
  //           details.velocity.pixelsPerSecond.distance.toString());
  //       print("onDragEnd Offeset= " + details.offset.direction.toString());
  //     },
  //     onDraggableCanceled: (Velocity velocity, Offset offset) {
  //       print("onDraggableCanceled " + velocity.toString());
  //     },
  //   );
  // }

  // Widget _buildDragTargetWithData(BuildContext context, int index, Offset ofset,
  //     QuestionService store, List<Question> questions) {
  //   final ReactiveModel<QuestionService> questionModelRM =
  //       Injector.getAsReactive<QuestionService>(context: context);
  //   Size media = MediaQuery.of(context).size;
  //   return Positioned(
  //     top: ofset.dy,
  //     left: ofset.dx,
  //     child: DragTarget(
  //       builder: (BuildContext context, List<String> candidateData,
  //           List<dynamic> rejectedData) {
  //         print("candidateData = " +
  //             candidateData.toString() +
  //             " , rejectedData = " +
  //             rejectedData.toString());
  //         return buildBox(SVG(questions[0].answers[index].answer),
  //             media.width / 2, media.width / 3);
  //       },
  //       onWillAccept: (data) {
  //         print("onWillAccept and data:$data");
  //         return true; // return true or false. can use and/or
  //       },
  //       onAccept: (data) {
  //         questionModelRM.setState((state) {
  //           if (questions[0].answers[index].isCorrect) {
  //             //store.correctCounter++;
  //             // _counter < 10 ? _counter++ : _counter = 0;
  //             store.toggleAnswerCorrect(true);
  //             store.correctCounter++;
  //             store.pushAnswerToList(questions[0].sId, true);
  //           } else {
  //             store.wrongCounter++;
  //             store.pushAnswerToList(questions[0].sId, false);
  //           }

  //           store.toggleDragCompleted(true);
  //         });

  //         print("onAccept and data:$data counter:$store.counter");
  //       },
  //       onLeave: (data) {
  //         print("onLeave and data:$data");
  //       },
  //     ),
  //   );
  // }

  // Widget buildBox(SVG svg, double width, double height) {
  //   return Container(
  //       width: width,
  //       height: height,
  //       decoration: BoxDecoration(
  //           //  borderRadius: BorderRadius.circular(size / 2),
  //           // color: color,
  //           ),
  //       child: svg);
  // }

}
