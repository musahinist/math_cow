import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_cow/components/app_bar.dart';
import 'package:math_cow/components/circular_progress_indicator.dart';
import 'package:math_cow/components/progress_indicator.dart';
import 'package:math_cow/data/model/topic.dart';
import 'package:math_cow/data/model/user.dart';
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
  int index = 0;
  @override
  Widget build(BuildContext context) {
    // setTopics();

    return WhenRebuilder<TopicService>(
      models: [Injector.getAsReactive<TopicService>()],
      onIdle: () => Center(child: Loading()),
      onWaiting: () => Center(child: Loading()),
      onError: (_) => Text("error"),
      onData: (store) => Stack(
        children: <Widget>[
          ListView(
            physics: BouncingScrollPhysics(),
            children: List<Widget>.generate(store.topics.length,
                (i) => _buildTopicsWithData(context, store.topics[i], store, i))
              ..insert(0, _hero(context, store)),
          ),
          TransAppBar(
            licon: Icons.featured_play_list,
            ltext:
                "${store.me.finishedCards.length}" ?? "0", //"${store.me.name}",
            ctext: "GAMES",
            rtext: Text("${store.me.points}"),
            ricon: Icons.monetization_on,
          ),
        ],
      ),
    );
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
    List matchTablo = [];

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
                itemBuilder: (context, j) {
                  var isOpen = store.me.finishedCards.any((value) =>
                      value.topicID == data.topicID &&
                      value.cardID == data.cards[j].cardID);
                  matchTablo.add(isOpen);

                  return _buildSubjectCard(context, matchTablo, j,
                      data.cards[j], data.topicID, store, i);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, List matchTablo, int j,
      Cards card, String topicID, TopicService store, i) {
    int before = j - 1 < 0 ? 0 : j - 1;
    return GestureDetector(
      onTap: () {
        if (matchTablo[j] || matchTablo[before] || (j == 0)) {
          this.index = 0;
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
          color: (matchTablo[j] || matchTablo[before] || (j == 0))
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
            _cardLock(store, j, topicID, i, matchTablo, before),
          ],
        ),
      ),
    );
  }

  Widget _cardLock(TopicService store, int j, String topicID, i,
      List matchTablo, int before) {
    //print(matchTablo[j]);
    if (matchTablo[j]) {
      //  print(this.index);
    }
    if (matchTablo[j] && this.index < store.me.finishedCards.length) {
      var a = store.me.finishedCards
        ..sort((a, b) => int.parse(a.topicID).compareTo(int.parse(b.topicID)));

      var accr = a[this.index].accuracyPercentageInCard.toStringAsFixed(0);
      var row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.star,
              color: a[this.index].accuracyPercentageInCard < 50
                  ? Colors.red
                  : Colors.amber[800]),
          Text("$accr%")
        ],
      );
      this.index++;
      return row;
    } else if (j == 0) {
      return Icon(Icons.lock_open);
    } else if (matchTablo[before]) {
      return Icon(Icons.lock_open);
    } else {
      return Icon(Icons.lock);
    }
  }

  Widget _withRoundedRectangleBorder(BuildContext context, int i, String cardID,
      String topicID, String userID) {
    this.index = 0;
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
