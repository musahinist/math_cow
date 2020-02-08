import 'package:flutter/material.dart';
import "package:flare_flutter/flare_actor.dart";

import 'package:math_cow/data/model/question.dart';
import 'package:math_cow/screens/game/drag-drop-game.dart';
import 'package:math_cow/screens/game/flip_game.dart';
import 'package:math_cow/screens/game/tinder-card.dart';
import 'package:math_cow/screens/game/training.dart';
import 'package:math_cow/utils/count-down-timer.dart';

import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/components/app_bar.dart';
import 'package:math_cow/components/progress_indicator.dart';
import 'package:math_cow/utils/draw_svg.dart';
import 'package:math_cow/utils/loading_anim.dart';

class GamePage extends StatelessWidget {
  final String id;
  GamePage({Key key, @required this.id}) : super(key: key);
  // int _start = 10;
  // int _current = 10;

  // void startTimer() {
  //   CountdownTimer countDownTimer = new CountdownTimer(
  //     new Duration(seconds: _start),
  //     new Duration(seconds: 1),
  //   );

  //   var sub = countDownTimer.listen(null);
  //   sub.onData((duration) {
  //     _current = _start - duration.elapsed.inSeconds;
  //     print(_current);
  //   });

  //   sub.onDone(() {
  //     print("Done");
  //     sub.cancel();
  //   });
  // }

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
                    //traininig yukarda olmalı yoksa suffle edilmiş sorualrdan alıyor
                    var trainingQ = store.trainingQuestions;
                    var questions = store.questions;

                    return _gameStack(context, store, questions, trainingQ);
                  }, //FlipGame(), //
                  onError: (_) => Text("error"),
                );
              },
            )));
  }

  Stack _gameStack(BuildContext context, QuestionService store,
      List<Question> questions, trainigQ) {
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
      FlipGame(
        questions: questions,
        store: store,
      ),
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
          rtext: CntdTimer(store: store),
          ricon: Icons.timelapse,
        ),
        store.isDragCompleted == false
            ? Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  store.training
                      ? Training(
                          trainingQuestions: trainigQ,
                          store: store,
                        )
                      : gameList[0],
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
                  ),
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
                        if (store.correctCounter == 2 ||
                            store.remainingTime == 0) {
                          store.addUserData();
                          return _showDialog(context, store);
                        } else if (store.index + 1 < 4 &&
                            store.correctCounter < 2) {
                          store.indexIncrement();
                          store.toggleDragCompleted(false);
                          store.toggleAnswerCorrect(false);
                        } else {
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
          return WillPopScope(
            onWillPop: () {},
            child: Center(
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
                          // Navigator.of(context)
                          //     .popUntil(ModalRoute.withName('/'));
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/', ModalRoute.withName("/game"));

                          // Navigator.pop(context);
                        },
                      ),
                    ),
                    // Text(
                    //   "You Just Finished a Card",
                    //   style: TextStyle(fontSize: 16, inherit: false),
                    // ),
                    Text(
                      store.correctCounter == 5 ? "Congrats" : "Try Again",
                      style: TextStyle(fontSize: 20, inherit: false),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

// class CountDownTimer extends StatefulWidget {
//   const CountDownTimer({
//     Key key,
//     int secondsRemaining,
//     this.countDownTimerStyle,
//     this.whenTimeExpires,
//     this.countDownFormatter,
//   })  : secondsRemaining = secondsRemaining,
//         super(key: key);

//   final int secondsRemaining;
//   final Function whenTimeExpires;
//   final Function countDownFormatter;
//   final TextStyle countDownTimerStyle;

//   State createState() => new _CountDownTimerState();
// }

// class _CountDownTimerState extends State<CountDownTimer>
//     with TickerProviderStateMixin {
//   AnimationController _controller;
//   Duration duration;

//   String get timerDisplayString {
//     Duration duration = _controller.duration * _controller.value;
//     return widget.countDownFormatter != null
//         ? widget.countDownFormatter(duration.inSeconds)
//         : formatHHMMSS(duration.inSeconds);
//     // In case user doesn't provide formatter use the default one
//     // for that create a method which will be called formatHHMMSS or whatever you like
//   }

//   String formatHHMMSS(int seconds) {
//     int hours = (seconds / 3600).truncate();
//     seconds = (seconds % 3600).truncate();
//     int minutes = (seconds / 60).truncate();

//     String hoursStr = (hours).toString().padLeft(2, '0');
//     String minutesStr = (minutes).toString().padLeft(2, '0');
//     String secondsStr = (seconds % 60).toString().padLeft(2, '0');

//     if (hours == 0) {
//       return "$minutesStr:$secondsStr";
//     }

//     return "$hoursStr:$minutesStr:$secondsStr";
//   }

//   @override
//   void initState() {
//     super.initState();
//     duration = new Duration(seconds: widget.secondsRemaining);
//     _controller = new AnimationController(
//       vsync: this,
//       duration: duration,
//     );
//     _controller.reverse(from: widget.secondsRemaining.toDouble());
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed ||
//           status == AnimationStatus.dismissed) {
//         widget.whenTimeExpires();
//       }
//     });
//   }

//   @override
//   void didUpdateWidget(CountDownTimer oldWidget) {
//     if (widget.secondsRemaining != oldWidget.secondsRemaining) {
//       setState(() {
//         duration = new Duration(seconds: widget.secondsRemaining);
//         _controller.dispose();
//         _controller = new AnimationController(
//           vsync: this,
//           duration: duration,
//         );
//         _controller.reverse(from: widget.secondsRemaining.toDouble());
//         _controller.addStatusListener((status) {
//           if (status == AnimationStatus.completed) {
//             widget.whenTimeExpires();
//           } else if (status == AnimationStatus.dismissed) {
//             print("Animation Complete");
//           }
//         });
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Center(
//         child: AnimatedBuilder(
//             animation: _controller,
//             builder: (_, Widget child) {
//               return Text(
//                 timerDisplayString,
//                 style: widget.countDownTimerStyle,
//               );
//             }));
//   }
// }
