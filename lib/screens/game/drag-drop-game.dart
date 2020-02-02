import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:math_cow/data/model/question.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/utils/draw_svg.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class DragDropGame extends StatelessWidget {
  const DragDropGame({Key key, this.store, this.questions}) : super(key: key);
  final questions;
  final store;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    List<Offset> ofsetlist = [
      Offset(0, media.height / 7),
      Offset(media.width / 2, media.height / 7),
      Offset(0, media.height * 6 / 7 - media.width / 3),
      Offset(media.width / 2, media.height * 6 / 7 - media.width / 3)
    ]..shuffle();
    List shuffuleAnswer = [1, 2, 3, 4, 5]..shuffle();
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        _buildDraggable(
          context,
          Offset(0 /*media.width / 2 - media.width * .18*/,
              media.height / 2 - media.width * .18),
          questions[0].question,
        ),
        Stack(
          children: <Widget>[
            _buildDragTargetWithData(
                context, 0, ofsetlist[0], store, questions),
            _buildDragTargetWithData(
                context, shuffuleAnswer[1], ofsetlist[1], store, questions),
            _buildDragTargetWithData(
                context, shuffuleAnswer[2], ofsetlist[2], store, questions),
            _buildDragTargetWithData(
                context, shuffuleAnswer[3], ofsetlist[3], store, questions),
          ],
        ),
      ],
    );
  }

  Widget _buildDraggable(BuildContext context, Offset ofset, String svg) {
    Size media = MediaQuery.of(context).size;
    return Draggable(
      maxSimultaneousDrags: 1,
      ignoringFeedbackSemantics: false,
      dragAnchor: DragAnchor.child,
      child: buildBox(svg, media.width, media.width / 3 /*media.width * .36*/
          ), //buildCircledBox(svg, media.width * .36, color: Colors.black12),
      feedback: buildBox(svg, media.width, media.width / 3 /*media.width * .36*/
          ),
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
    );
  }

  Widget _buildDragTargetWithData(BuildContext context, int index, Offset ofset,
      QuestionService store, List<Question> questions) {
    final ReactiveModel<QuestionService> questionModelRM =
        Injector.getAsReactive<QuestionService>(context: context);
    Size media = MediaQuery.of(context).size;
    return Positioned(
      top: ofset.dy,
      left: ofset.dx,
      child: DragTarget(
        builder: (BuildContext context, List<String> candidateData,
            List<dynamic> rejectedData) {
          print("candidateData = " +
              candidateData.toString() +
              " , rejectedData = " +
              rejectedData.toString());
          return buildBox(questions[0].answers[index].answer, media.width / 2,
              media.width / 3);
        },
        onWillAccept: (data) {
          print("onWillAccept and data:$data");
          return true; // return true or false. can use and/or
        },
        onAccept: (data) {
          questionModelRM.setState((state) {
            if (questions[0].answers[index].isCorrect) {
              //store.correctCounter++;
              // _counter < 10 ? _counter++ : _counter = 0;
              store.toggleAnswerCorrect(true);
              store.correctCounter++;
              store.pushAnswerToList(questions[0].sId, true);
            } else {
              store.wrongCounter++;
              store.pushAnswerToList(questions[0].sId, false);
            }

            store.toggleDragCompleted(true);
          });

          print("onAccept and data:$data counter:$store.counter");
        },
        onLeave: (data) {
          print("onLeave and data:$data");
        },
      ),
    );
  }

  Widget buildBox(String svg, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          //  borderRadius: BorderRadius.circular(size / 2),
          // color: color,
          ),
      child: Center(
        child: SvgPicture.string(
          svg,
          allowDrawingOutsideViewBox: true,
        ),
      ),
    );
  }
}
