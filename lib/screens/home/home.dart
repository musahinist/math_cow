import 'package:flutter/material.dart';
import 'package:math_cow/components/app_bar.dart';
import 'package:math_cow/data/provider/topic_api.dart';

import 'package:math_cow/data/services/topic_service.dart';

import 'package:math_cow/screens/home/card_list_view.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class HomePage extends StatelessWidget {
  //HomePage({Key key}) : super(key: key);
  final tween = MultiTrackTween([
    Track("color1").add(Duration(seconds: 23),
        ColorTween(begin: Colors.pink[300], end: Colors.limeAccent[700])),
    Track("color2").add(Duration(seconds: 17),
        ColorTween(begin: Colors.purpleAccent, end: Colors.cyan[300])),
    Track("color3").add(Duration(seconds: 19),
        ColorTween(begin: Colors.cyan[200], end: Colors.purpleAccent)),
  ]);

  @override
  Widget build(BuildContext context) {
    return ControlledAnimation(
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
                  ]),
            ),
            child: Injector(
              inject: [
                Inject<TopicService>(() => TopicService(tapi: TopicApi())),
                /*Inject<QuestionService>(() => QuestionService(api: API()))*/
              ],
              initState: () {
                final ReactiveModel<TopicService> topicModelRM =
                    Injector.getAsReactive<TopicService>();
                topicModelRM.setState((state) => state.getTopics());
              },
              builder: (context) {
                //  final ReactiveModel<TopicService> topicModelRM =
                // Injector.getAsReactive<TopicService>();
                return Stack(
                  children: <Widget>[
                    CardListView(),
                    TransAppBar(
                      licon: Icons.toys,
                      ltext: " 25 Cards",
                      ctext: "TOPICS",
                      rtext: "03:00",
                      ricon: Icons.timelapse,
                    ),
                  ],
                );
              },
            ));
      },
    );
  }
}
