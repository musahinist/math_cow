import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_cow/components/flip_card.dart';
import 'package:math_cow/components/flipper.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/utils/draw_svg.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:swipe_stack/swipe_stack.dart';

class Training extends StatelessWidget {
  List trainingQuestions;
  final store;
  final GlobalKey<SwipeStackState> _swipeKey = GlobalKey<SwipeStackState>();
  Training({this.store, this.trainingQuestions});
  // Color color(SwiperPosition dir, double prgrs) {
  //   if (dir == SwiperPosition.Right) {
  //     return Color.fromRGBO(0, 240, 100, 0.3 + 0.01 * prgrs);
  //   } else if (dir == SwiperPosition.Left) {
  //     return Color.fromRGBO(240, 30, 0, 0.3 + 0.01 * prgrs);
  //   }
  //   return Color.fromRGBO(255, 255, 0, .6);
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ReactiveModel<QuestionService> questionModelRM =
        Injector.getAsReactive<QuestionService>();
//trainingQuestions.map
    return Stack(
      children: <Widget>[
        // Positioned(
        //   bottom: size.height * .1,
        //   left: size.width * .1,
        //   child: Icon(
        //     Icons.cancel,
        //     color: Colors.red,
        //     size: size.width * .2,
        //   ),
        // ),

        // Positioned(
        //   bottom: size.height * .1,
        //   right: size.width * .1,
        //   child: Icon(
        //     Icons.check_circle,
        //     color: Colors.green,
        //     size: size.width * .2,
        //   ),
        // ),
        SwipeStack(
          children: Iterable<int>.generate(trainingQuestions.length)
              .toList()
              .reversed
              .take(1)
              .map(
            (int index) {
              return SwiperItem(
                builder: (SwiperPosition position, double progress) {
                  return Padding(
                      padding: EdgeInsets.fromLTRB(size.width * .04,
                          size.height * .2, size.width * .04, size.height * .2),
                      child: FlipperCard(trainingQuestions));
                },
              );
            },
          ).toList(),
          visibleCount: 2,
          key: _swipeKey,
          maxAngle: 70,
          stackFrom: StackFrom.Bottom,
          translationInterval: 6,
          scaleInterval: 0.03,
          onEnd: () {
            questionModelRM.setState(
              (state) {
                // if (position == SwiperPosition.Right && randIndex == 0 ||
                //     position == SwiperPosition.Left && randIndex != 0) {
                store.toggleAnswerCorrect(true);

                store.correctCounter = 0;
                //   store.pushAnswerToList(questions.sId, true);
                // } else if (position == SwiperPosition.Right && randIndex != 0 ||
                //     position == SwiperPosition.Left && randIndex == 0) {
                //   store.wrongCounter++;
                //   store.pushAnswerToList(questions.sId, false);
                // }
                store.training = false;
                return store.toggleDragCompleted(true);
              },
            );
          },
          onRewind: (int index, SwiperPosition position) =>
              debugPrint("onRewind $index $position"),
          onSwipe: (int index, SwiperPosition position) {
            _swipeKey.currentState.clearHistory();
          },
        ),
      ],
    );
  }
}
