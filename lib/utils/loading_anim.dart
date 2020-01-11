import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading();
  @override
  Widget build(BuildContext context) {
    return FlareActor(
      "animations/Loading.flr",
      alignment: Alignment.center,
      fit: BoxFit.contain,
      sizeFromArtboard: true,
      animation: "Alarm",
    );
  }
}
