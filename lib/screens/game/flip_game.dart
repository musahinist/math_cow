import 'package:flutter/material.dart';
import 'package:math_cow/components/flipper.dart';
import 'package:math_cow/utils/fade_animation.dart';

class FlipGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return GridView.count(
      padding: EdgeInsets.symmetric(vertical: 70),
      childAspectRatio: (media.width / 3) / (media.height / 4.9),
      // Create a grid with 3 columns. If you change the scrollDirection to
      // horizontal, this produces 3 rows.
      crossAxisCount: 3,
      // Generate 12 widgets that display their index in the List.
      children: List.generate(12, (index) {
        return FadeAnimation(index * 0.1, FlipperWidget());
      }),
    );
  }
}
