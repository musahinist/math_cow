import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'dart:math';

import 'package:math_cow/utils/fade_animation.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class FlipGame3 extends StatelessWidget {
  final List questions;
  final store;

  FlipGame3({this.questions, this.store});

  Map<String, dynamic> state = {
    "anime": true,
    "gsem": "",
    "asem": "",
    "correctCount": 0,
    "counter": 0,
    "isCorrect": false,
  };

  @override
  Widget build(BuildContext context) {
    final question = questions.take(3).map((value) => value).toList();
    final answer = questions.take(3).map((value) => value).toList()..shuffle();
    final media = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: question
                    .map((value) => Fliper(
                          value: value.question,
                          store: store,
                          type: 0,
                          answer: value.semanticAnswer,
                          state: state,
                        ))
                    .toList()),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: answer
                    .map((value) => Fliper(
                          value: value.answers[0].answer,
                          store: store,
                          type: 1,
                          answer: value.semanticAnswer,
                          state: state,
                        ))
                    .toList()),
          ],
        ),
      ),
    );
  }
}

class Fliper extends StatefulWidget {
  final type;
  final value;
  final store;
  final answer;

  Map<String, dynamic> state;

  Fliper({this.value, this.store, this.type, this.answer, this.state});
  @override
  _FliperState createState() => _FliperState();
}

class _FliperState extends State<Fliper> with SingleTickerProviderStateMixin {
  bool reversed;
  Animation<double> _animation;
  AnimationController _animationController;
  bool isCorrect;
  Function setGame;

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

  String feedBack = "😞";
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: Center(
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
                  if ((widget.state["anime"] && widget.type == 0) ||
                      (!widget.state["anime"] && widget.type == 1)) {
                    _doAnim();
                    widget.state["anime"]
                        ? widget.state["gsem"] = widget.answer
                        : widget.state["asem"] = widget.answer;
                    widget.state["counter"]++;
                    print(widget.state["counter"]);

                    if (!widget.state["anime"] &&
                        widget.state["gsem"] == widget.state["asem"]) {
                      isCorrect = true;
                      feedBack = "😄";
                      //isCorrect = true;
                      widget.state["correctCount"]++;
                      print("corretCount: ${widget.state["correctCount"]}");
                    }
                    widget.state["anime"] = !widget.state["anime"];
                  }
                  if (widget.state["counter"] == 6) {
                    questionModelRM.setState((state) {
                      if (widget.state["correctCount"] >= 2) {
                        widget.store.correctCounter++;
                        widget.store.toggleAnswerCorrect(true);
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
                  buildCardOne(widget.value,
                      widget.type == 0 ? Colors.green : Colors.red),
                  buildCardTwo(
                      widget.type == 0 ? "🤔" : feedBack, Colors.transparent)
                ],
                alignment: Alignment.center,
                index: _animationController.value < 0.5 ? 0 : 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardOne(String front, Color color) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
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
