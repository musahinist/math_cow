import 'package:flutter/material.dart';

import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:math_cow/data/provider/topic_api.dart';
import 'package:math_cow/data/services/topic_service.dart';
import 'package:math_cow/screens/home/card_list_view.dart';
import 'package:simple_animations/simple_animations.dart';

class HomePage extends StatelessWidget {
  final tween = MultiTrackTween([
    Track("color1").add(Duration(seconds: 23),
        ColorTween(begin: Color(0xFFAD5389), end: Color(0xFFFFC125))),
    Track("color2").add(Duration(seconds: 17),
        ColorTween(begin: Color(0xFF845EC2), end: Color(0xFF66C5CC))),
    Track("color3").add(Duration(seconds: 19),
        ColorTween(begin: Color(0xFF3C1053), end: Color(0xFFF87777))),
  ]);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ControlledAnimation(
          playback: Playback.MIRROR,
          tween: tween,
          duration: tween.duration,
          builder: (context, animation) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [
                    animation["color1"],
                    animation["color2"],
                    animation["color3"]
                  ],
                ),
              ),
            );
          },
        ),
        Injector(
          inject: [Inject<TopicService>(() => TopicService(tapi: TopicApi()))],
          initState: () {
            final ReactiveModel<TopicService> topicModelRM =
                Injector.getAsReactive<TopicService>();
            topicModelRM.setState((state) => state.getMainPageData());
          },
          builder: (context) {
            return CardListView();
          },
        ),
      ],
    );
  }
}
