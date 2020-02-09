import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'dart:math';

import 'package:math_cow/utils/fade_animation.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class FlipGame extends StatelessWidget {
  final List questions;
  final store;

  FlipGame({this.questions, this.store});
  @override
  Widget build(BuildContext context) {
    // List cards = [questions[0]];
    // for (int i = 1; i < 20; i++) {
    //   for (int j = 0; j < cards.length; j++) {
    //     bool equal =
    //         questions[i].answers[0].answer != cards[j].answers[0].answer;
    //     if (equal) {
    //       cards.add(questions[i]);
    //     }
    //   }
    // }
    // print(cards);
    List question = questions.take(6).map(
      (value) {
        return Fliper(
            value: value.question,
            index: value.questionID,
            store: store,
            type: 0);
      },
    ).toList();
    List answer = questions.take(6).map(
      (value) {
        return Fliper(
            value: value.answers[0].answer,
            index: value.questionID,
            store: store,
            type: 1);
      },
    ).toList();

    final media = MediaQuery.of(context).size;
    return GridView.custom(
        padding: EdgeInsets.symmetric(vertical: 50),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        // childAspectRatio: (media.width / 3) / (media.height / 4.9),
        // Create a grid with 3 columns. If you change the scrollDirection to
        // horizontal, this produces 3 rows.
        //  crossAxisCount: 3,
        // Generate 12 widgets that display their index in the List.
        childrenDelegate:
            SliverChildListDelegate([...question, ...answer..shuffle()]));
  }
}

class Fliper extends StatefulWidget {
  final type;
  final value;
  final store;

  final index;

  Fliper({this.value, this.store, this.type, this.index});
  @override
  _FliperState createState() => _FliperState();
}

bool qcanAnim = true;
bool acanAnim = false;
String qid;
String aid;
int counter = 0;
int ccount = 0;

class _FliperState extends State<Fliper> with SingleTickerProviderStateMixin {
  bool reversed;
  Animation<double> _animation;
  AnimationController _animationController;
  bool isCorrect;

  @override
  void initState() {
    super.initState();
    isCorrect = false;
    reversed = false;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -pi / 2), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: pi / 2, end: 0.0), weight: 0.5)
    ]).animate(_animationController);
  }

  final ReactiveModel<QuestionService> questionModelRM =
      Injector.getAsReactive<QuestionService>();
  _doAnim() {
    if (!mounted) return;
    // if (reversed) {
    //   _animationController.reverse();
    //   reversed = false;
    // } else {
    //   _animationController.forward();
    //   reversed = true;
    // }
    if (!reversed) {
      _animationController.forward();
      reversed = true;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_animation.value),
          child: GestureDetector(
            onTap: () {
              if (!reversed) {
                if ((qcanAnim && widget.type == 0) ||
                    (acanAnim && widget.type == 1)) {
                  _doAnim();
                  qcanAnim ? qid = widget.index : aid = widget.index;
                  counter++;
                  print(counter);

                  if (acanAnim && qid == aid) {
                    isCorrect = true;
                    ccount++;
                    print("corretCount: $ccount");
                  }
                  qcanAnim = !qcanAnim;
                  acanAnim = !acanAnim;
                }
                if (counter == 12) {
                  counter = 0;
                  qcanAnim = true;
                  acanAnim = false;
                  // dispose();
                  questionModelRM.setState((state) {
                    if (ccount >= 3) {
                      widget.store.correctCounter++;
                      widget.store.toggleAnswerCorrect(true);
                      ccount = 0;
                    } else {
                      widget.store.wrongCounter++;
                    }

                    return widget.store.toggleDragCompleted(true);
                  });
                }
              }
            },
            child: IndexedStack(
              children: <Widget>[
                buildCardOne(
                    widget.value, widget.type == 0 ? Colors.green : Colors.red),
                buildCardTwo("?", Colors.transparent)
              ],
              alignment: Alignment.center,
              index: _animationController.value < 0.5 ? 0 : 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardOne(String front, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            new BoxShadow(
              color: Colors.black26,
              offset: new Offset(2.0, 2.0),
              blurRadius: 8.0,
            )
          ],
        ),
        child: Center(
            child: SvgPicture.string(
          front,
          allowDrawingOutsideViewBox: true,
          fit: BoxFit.cover,
          width: 50,
        )),
      ),
    );
  }

  Widget buildCardTwo(String total, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: color,
        // decoration: BoxDecoration(
        //   color: color,
        //   borderRadius: BorderRadius.circular(5.0),
        //   boxShadow: [
        //     new BoxShadow(
        //       color: Colors.black26,
        //       offset: new Offset(2.0, 2.0),
        //       blurRadius: 8.0,
        //     )
        //   ],
        // ),
        child: Center(
          child: Text(
            "$total",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
            ),
          ),
        ),
      ),
    );
  }
}

// class CardOne extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {

//     return Card(
//       color: Colors.red,
//       child: Container(
//         width: 200,
//         height: 200,
//         child: Center(
//           child: Text(
//             "$x1 + $x2",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 35.0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CardTwo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.teal,
//       child: Container(
//         width: 200,
//         height: 200,
//         child: Center(
//           child: Text(
//             "$total",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 35.0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
