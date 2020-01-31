import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/utils/draw_svg.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:swipe_stack/swipe_stack.dart';

class TinderCard extends StatelessWidget {
  final questions;
  final store;

  TinderCard({this.store, this.questions});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final randIndex = Random().nextInt(2);
    final ReactiveModel<QuestionService> questionModelRM =
        Injector.getAsReactive<QuestionService>();

    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 100,
          left: 90,
          child: Icon(
            Icons.cancel,
            color: Colors.red,
            size: 80.0,
          ),
        ),
        Positioned(
          bottom: 100,
          right: 90,
          child: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80.0,
          ),
        ),
        SwipeStack(
          children: [0].map(
            (int index) {
              return SwiperItem(
                builder: (SwiperPosition position, double progress) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                        size.width * .1, size.height * .25, size.width * .1, 0),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        height: size.height * .4,
                        decoration: BoxDecoration(
                          color: Colors.orange[800],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: size.width * .8,
                                height: size.height * .2,
                                child: SVG(questions.question)),
                            Container(
                                width: size.width * .4,
                                height: size.height * .2,
                                child:
                                    SVG(questions.answers[randIndex].answer)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ).toList(),
          visibleCount: 3,
          maxAngle: 70,
          stackFrom: StackFrom.None,
          translationInterval: 6,
          scaleInterval: 0.03,
          onEnd: () => debugPrint("onEnd"),
          onRewind: (int index, SwiperPosition position) =>
              debugPrint("onRewind $index $position"),
          onSwipe: (int index, SwiperPosition position) {
            questionModelRM.setState(
              (state) {
                if (position == SwiperPosition.Right && randIndex == 0 ||
                    position == SwiperPosition.Left && randIndex != 0) {
                  store.toggleAnswerCorrect(true);
                  store.correctCounter++;
                  store.pushAnswerToList(questions.sId, true);
                } else if (position == SwiperPosition.Right && randIndex != 0 ||
                    position == SwiperPosition.Left && randIndex == 0) {
                  store.wrongCounter++;
                  store.pushAnswerToList(questions.sId, false);
                }

                return store.toggleDragCompleted(true);
              },
            );
          },
        ),
      ],
    );
  }
}
