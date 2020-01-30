import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/utils/draw_svg.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class TinderGame extends StatelessWidget {
  final questions;
  final store;
  final randIndex = Random().nextInt(2);
  TinderGame({this.store, this.questions});
  @override
  Widget build(BuildContext context) {
    //  CardController controller; //Use this to trigger swap.
    final ReactiveModel<QuestionService> questionModelRM =
        Injector.getAsReactive<QuestionService>(context: context);
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: new TinderSwapCard(
            orientation: AmassOrientation.BOTTOM,
            totalNum: 1,
            stackNum: 2,
            swipeEdge: 6.0,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.width * 1.1,
            minWidth: MediaQuery.of(context).size.width * 0.8,
            minHeight: MediaQuery.of(context).size.width * 0.8,
            cardBuilder: (context, index) => Card(
                  elevation: 5,
                  color: Colors.pink,
                  child: Column(
                    children: <Widget>[
                      Expanded(child: SVG(questions[0].question)),
                      Expanded(
                          child: SVG(questions[0].answers[randIndex].answer)),
                    ],
                  ),
                ),
            //  cardController: controller = CardController(),
            swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
              /// Get swiping card's alignment
              if (align.x < 0) {
                //Card is LEFT swiping
                print("left swipe");
              } else if (align.x > 0) {
                //Card is RIGHT swiping
                print("right swipe");
              }
            },
            swipeCompleteCallback:
                (CardSwipeOrientation orientation, int index) {
              print(orientation.index.toString());

              questionModelRM.setState((state) {
                if (orientation.index == 1 && randIndex == 0 ||
                    orientation.index == 0 && randIndex != 0) {
                  store.toggleAnswerCorrect(true);
                  store.correctCounter++;
                  store.pushAnswerToList(questions[0].sId, true);
                } else if (orientation.index == 1 && randIndex != 0 ||
                    orientation.index == 0 && randIndex == 0) {
                  store.wrongCounter++;
                  store.pushAnswerToList(questions[0].sId, false);
                }

                if (orientation.index != 2) {
                  return store.toggleDragCompleted(true);
                }
              });
            }),
      ),
    );
  }
}
