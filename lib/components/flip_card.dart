import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';

import 'package:math_cow/utils/draw_svg.dart';

class FlipperCard extends StatefulWidget {
  final List trainingQ;
  FlipperCard(this.trainingQ);
  @override
  _FlipperCardState createState() => _FlipperCardState();
}

class _FlipperCardState extends State<FlipperCard>
    with SingleTickerProviderStateMixin {
  bool reversed = false;
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -pi / 2), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: pi / 2, end: 0.0), weight: 0.5)
    ]).animate(_animationController);
  }

  _doAnim() {
    if (!mounted) return;
    if (reversed) {
      _animationController.reverse();
      reversed = false;
    } else {
      _animationController.forward();
      reversed = true;
    }
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
            onTap: _doAnim,
            child: IndexedStack(
              children: <Widget>[
                buildCard(widget.trainingQ[0]),
                buildCard(widget.trainingQ[1])
              ],
              alignment: Alignment.center,
              index: _animationController.value < 0.5 ? 0 : 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(String value) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Center(
              child: SvgPicture.string(
                value,
                allowDrawingOutsideViewBox: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SvgPicture.asset(
                "svg/flip-gesture.svg",
                allowDrawingOutsideViewBox: true,
                color: Colors.black45,
                height: 60,
              ),
              SvgPicture.asset(
                "svg/swap-gesture.svg",
                allowDrawingOutsideViewBox: true,
                color: Colors.black45,
                height: 60,
              ),
            ],
          )
        ],
      ),
    );
  }

//   Widget buildCardTwo(String back) {
//     return Card(
//       color: Colors.teal,
//       child: Container(
//         // width: 200,
//         // height: 200,
//         child: Center(
//           child:  SVG(back),
//         ),
//       ),
//     );
//   }
// }

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
}
