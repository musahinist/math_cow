import 'package:flutter/material.dart';
import 'dart:math';

class FlipperWidget extends StatefulWidget {
  @override
  _FlipperWidgetState createState() => _FlipperWidgetState();
}

class _FlipperWidgetState extends State<FlipperWidget>
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
    var x1 = Random().nextInt(100);
    var x2 = Random().nextInt(100);
    var total = x1 + x2;
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
                buildCardOne("$x1 + $x2"),
                buildCardTwo("$total")
              ],
              alignment: Alignment.center,
              index: _animationController.value < 0.5 ? 0 : 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardOne(String x) {
    return Card(
      color: Colors.red,
      child: Container(
        // width: 200,
        // height: 200,
        child: Center(
          child: Text(
            "$x",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardTwo(String total) {
    return Card(
      color: Colors.teal,
      child: Container(
        // width: 200,
        // height: 200,
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
