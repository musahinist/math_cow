import 'package:flutter/material.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:math_cow/data/model/question.dart';
import 'package:math_cow/screens/game/drag-drop-game.dart';
import 'package:math_cow/screens/game/flip-game3.dart';
import 'package:math_cow/screens/game/tinder-card.dart';
import 'package:math_cow/screens/game/training.dart';
import 'package:math_cow/utils/count-down-timer.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/components/app_bar.dart';
import 'package:math_cow/components/progress_indicator.dart';
import 'package:math_cow/utils/loading_anim.dart';

class GamePage extends StatelessWidget {
  // final String id;
  // GamePage({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  resizeToAvoidBottomPadding: false,
      body: Container(
        //  color: Colors.amber[800],
        child: StateBuilder<QuestionService>(
          models: [Injector.getAsReactive<QuestionService>()],
          builder: (context, model) {
            return model.whenConnectionState(
              onIdle: () => Text("idle"),
              onWaiting: () => Center(child: Loading()),
              onData: (store) {
                var trainingQ = store.trainingQuestions;
                var questions = store.questions;
                // print(questions);

                return _gameStack(context, store, questions, trainingQ);
              }, //FlipGame(), //
              onError: (_) => Text("error"),
            );
          },
        ),
      ),
    );
  }

  Stack _gameStack(BuildContext context, QuestionService store,
      List<Question> questions, trainigQ) {
    final ReactiveModel<QuestionService> questionModelRM =
        Injector.getAsReactive<QuestionService>(context: context);

    var gameList = [
      DragDropGame(
        store: store,
        questions: questions,
      ),
      TinderCard(questions: questions[0], store: store),
      FlipGame3(questions: questions, store: store),
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
