import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/utils/draw_svg.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:swipe_stack/swipe_stack.dart';

class Training extends StatelessWidget {
  final questions;
  final store;

  Training({this.store, this.questions});
  Color color(SwiperPosition dir, double prgrs) {
    if (dir == SwiperPosition.Right) {
      return Color.fromRGBO(0, 240, 100, 0.3 + 0.01 * prgrs);
    } else if (dir == SwiperPosition.Left) {
      return Color.fromRGBO(240, 30, 0, 0.3 + 0.01 * prgrs);
    }
    return Color.fromRGBO(255, 255, 0, .6);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final randIndex = Random().nextInt(2);
    final ReactiveModel<QuestionService> questionModelRM =
        Injector.getAsReactive<QuestionService>();

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
          children: [0].map(
            (int index) {
              return SwiperItem(
                builder: (SwiperPosition position, double progress) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(size.width * .05,
                        size.height * .25, size.width * .05, 0),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        height: size.height * .4,
                        decoration: BoxDecoration(
                          color: color(position, progress),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: size.width * .9,
                                height: size.height * .2,
                                child: SVG(questions.question)),
                            Container(
                                width: size.width * .5,
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
