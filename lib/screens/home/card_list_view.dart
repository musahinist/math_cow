import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_cow/components/app_bar.dart';
import 'package:math_cow/components/circular_progress_indicator.dart';
import 'package:math_cow/components/progress_indicator.dart';
import 'package:math_cow/data/model/topic.dart';
import 'package:math_cow/data/provider/question_api.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/data/services/topic_service.dart';
import 'package:math_cow/data/services/user_service.dart';
import 'package:math_cow/screens/game/game.dart';
import 'package:math_cow/utils/fade_animation.dart';
import 'package:math_cow/utils/loading_anim.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class CardListView extends StatelessWidget {
  // final List<Question> topics;
  // CardListView(this.qs);

// final Future<List<Topic>>
  // void setTopics() {
  //   topics = api.getTopics();
  // }
  int i = 0;
  String cardID = "101";
  String topicID = "101";

  @override
  Widget build(BuildContext context) {
    // setTopics();

    return StateBuilder<TopicService>(
        models: [Injector.getAsReactive<TopicService>()],
        builder: (context, model) {
          return model.whenConnectionState(
            onIdle: () => Center(child: Loading()),
            onWaiting: () => Center(child: Loading()),
            onError: (_) => null,
            onData: (store) => Stack(
              children: <Widget>[
                ListView(
                  physics: BouncingScrollPhysics(),
                  children: List<Widget>.generate(store.topics.length,
                      (i) => _buildTopicsWithData(store.topics[i], store))
                    ..insert(0, _hero(context, store)),
                ),
                TransAppBar(
                  licon: Icons.toys,
                  ltext: "${store.me.finishedCards.length} Card" ??
                      "0", //"${store.me.name}",
                  ctext: "TOPICS",
                  rtext: "03:00",
                  ricon: Icons.timelapse,
                ),
              ],
            ),
          );
        });
  }

  Container _hero(BuildContext context, TopicService store) => Container(
        // height: MediaQuery.of(context).size.height / 4,
        // decoration: BoxDecoration(color: Colors.green),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "TOPIC 1",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    "Subject Card 0",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ProgressIndic(percent: Random().nextInt(10)),
                  SizedBox(
                    height: 20,
                  ),

                  // roundedButton(
                  //     title: "Continue",
                  //     color: Colors.orange[800],
                  //     margin: 210),
                  _withRoundedRectangleBorder(
                      context, i, cardID, topicID, store.me.sId),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildTopicsWithData(Topic data, TopicService store) {
    return FadeAnimation(
      0.2,
      Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(data.topicName),
              leading: Icon(
                Icons.speaker_notes,
              ),
            ),
            Container(
              height: 120.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: data.cards.length,
                itemBuilder: (context, i) => _buildSubjectCard(
                    context, i, data.cards[i], data.topicID, store.me.sId),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
      BuildContext context, int i, Cards card, String topicID, String userID) {
    return GestureDetector(
      onTap: () {
        this.i = i;
        this.cardID = card.cardID;
        this.topicID = topicID;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Injector(
                  inject: [
                    Inject<QuestionService>(
                        () => QuestionService(qapi: QuestionApi()))
                  ],
                  initState: () {
                    final ReactiveModel<QuestionService> questionModelRM =
                        Injector.getAsReactive<QuestionService>();
                    questionModelRM.setState((state) async {
                      await state.getQuestions("$topicID/${card.cardID}");
                      state.setCardandTopicId(cardId: cardID, topicId: topicID);
                      state.userID = userID;
                    });
                  },
                  builder: (context) => GamePage(id: "$topicID/${card.cardID}"),
                )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFB480),
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(20.0),
        margin: i == 0
            ? const EdgeInsets.only(left: 20.0)
            : const EdgeInsets.only(left: 10.0),
        width: 160.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(card.cardName,
                style: TextStyle(
                    color: Color(0xFF5E5E5E), fontWeight: FontWeight.bold)),
            ProgressIndic(percent: Random().nextInt(10)),
          ],
        ),
      ),
    );
  }

  Widget _withRoundedRectangleBorder(BuildContext context, int i, String cardID,
      String topicID, String userID) {
    return RaisedButton(
      elevation: 0,
      padding: const EdgeInsets.fromLTRB(
        45,
        20,
        45,
        20,
      ),
      color: Color(0xFFFFB480),
      child: Text(
        "Continue",
        style: TextStyle(color: Color(0xFF5E5E5E)),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Injector(
                  inject: [
                    Inject<QuestionService>(
                        () => QuestionService(qapi: QuestionApi()))
                  ],
                  initState: () {
                    final ReactiveModel<QuestionService> questionModelRM =
                        Injector.getAsReactive<QuestionService>();
                    questionModelRM.setState((state) async {
                      state.setCardandTopicId(cardId: cardID, topicId: topicID);
                      state.userID = userID;
                      await state.getQuestions("$topicID/$cardID");
                    });
                  },
                  builder: (context) => GamePage(id: "$topicID/$cardID"),
                )));
      },
    );
  }

  // Widget roundedButton({String title, Color color, double margin = 0}) {
  //   return InkWell(
  //     onTap: () => print('hello'),
  //     child: Container(
  //       height: 50,
  //       margin: EdgeInsets.only(right: margin),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(50), color: color),
  //       child: Center(
  //         child: Text(
  //           title,
  //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
