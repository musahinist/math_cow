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
  int hj = 0;
  String hcardID = "101";
  String htopicID = "101";

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
                  children: List<Widget>.generate(
                      store.topics.length,
                      (i) => _buildTopicsWithData(
                          context, store.topics[i], store, i))
                    ..insert(0, _hero(context, store)),
                ),
                TransAppBar(
                  licon: Icons.featured_play_list,
                  ltext: "${store.me.finishedCards.length}" ??
                      "0", //"${store.me.name}",
                  ctext: "GAMES",
                  rtext: "${store.me.points}",
                  ricon: Icons.monetization_on,
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

                  // roundedButton(
                  //     title: "Continue",
                  //     color: Colors.orange[800],
                  //     margin: 210),
                  _withRoundedRectangleBorder(
                      context, hj, hcardID, htopicID, store.me.sId),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildTopicsWithData(
      BuildContext context, Topic data, TopicService store, int i) {
    return FadeAnimation(
      0.2,
      Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(data.topicName),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: data.cards.length,
                itemBuilder: (context, j) => _buildSubjectCard(
                    context, j, data.cards[j], data.topicID, store, i),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, int j, Cards card,
      String topicID, TopicService store, i) {
    return GestureDetector(
      onTap: () {
        if ((store.me.finishedCards.length > j &&
                topicID == store.me.finishedCards[j].topicID) ||
            (j == 0) ||
            (store.me.finishedCards.length == j &&
                "${101 + i}" == store.me.finishedCards[j - 1].topicID)) {
          this.hj = j;
          this.hcardID = card.cardID;
          this.htopicID = topicID;
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
                        state.setCardandTopicId(
                            cardId: hcardID, topicId: htopicID);
                        state.userID = store.me.sId;
                      });
                    },
                    builder: (context) =>
                        GamePage(id: "$topicID/${card.cardID}"),
                  )));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: (store.me.finishedCards.length > j &&
                      topicID == store.me.finishedCards[j].topicID) ||
                  j == 0 ||
                  (store.me.finishedCards.length == j &&
                      "${101 + i}" == store.me.finishedCards[j - 1].topicID)
              ? Colors.grey[800]
              : Colors.grey[600],
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(20.0),
        margin: j == 0
            ? const EdgeInsets.only(left: 20.0)
            : const EdgeInsets.only(left: 10.0),
        width: MediaQuery.of(context).size.width * 0.37,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(card.cardName, style: TextStyle(fontWeight: FontWeight.bold)),
            _cardLock(store, j, topicID, i),
          ],
        ),
      ),
    );
  }

  Widget _cardLock(TopicService store, int j, String topicID, i) {
    if (store.me.finishedCards.length > j &&
        topicID == store.me.finishedCards[j].topicID) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.star,
              color: store.me.finishedCards[j].accuracyPercentageInCard < 50
                  ? Colors.red
                  : Colors.amber[800]),
          Text(
              "${store.me.finishedCards[j].accuracyPercentageInCard.toStringAsFixed(0)}%")
        ],
      );
    } else if (j == 0) {
      return Icon(Icons.lock_open);
    } else if (store.me.finishedCards.length == j &&
        "${101 + i}" == store.me.finishedCards[j - 1].topicID) {
      return Icon(Icons.lock_open);
    } else {
      return Icon(Icons.lock);
    }
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
      color: Colors.grey[800],
      child: Text(
        "Continue",
        // style: TextStyle(color: Colors.amber[800]),
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
